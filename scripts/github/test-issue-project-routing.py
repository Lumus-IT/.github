#!/usr/bin/env python3
"""Regressão local da inclusão concorrente de issues em Projects."""

import json
import os
from pathlib import Path
import subprocess
import tempfile
import textwrap
import unittest


WORKFLOW = Path(__file__).resolve().parents[2] / ".github/workflows/reusable-issue-project-routing.yml"

MOCK_GH = r'''#!/usr/bin/env python3
import json
import os
import sys

args = sys.argv[1:]
scenario = os.environ["MOCK_SCENARIO"]
log_path = os.environ["MOCK_LOG"]
with open(log_path, "a", encoding="utf-8") as log:
    log.write(json.dumps(args) + "\n")

if args == ["api", "repos/Lumus-IT/protos/issues/155"]:
    print(json.dumps({"node_id": "ISSUE", "title": "Issue de teste"}))
    sys.exit(0)

query = next((arg[6:] for arg in args if arg.startswith("query=")), "")
if "projectItems(first: 100)" in query:
    with open(log_path, encoding="utf-8") as log:
        query_count = sum("projectItems(first: 100)" in line for line in log)
    items = [{"id": "OTHER_ITEM", "project": {"id": "OTHER"}, "fieldValues": {"nodes": []}}]
    if scenario == "existing" or (query_count > 1 and scenario.startswith("duplicate")):
        if scenario != "duplicate_missing":
            status = "In-progress" if scenario == "duplicate_preserve" else ""
            values = [{"name": status, "field": {"name": "Status"}}] if status else []
            items.append({"id": "TARGET_ITEM", "project": {"id": "TARGET"},
                          "fieldValues": {"nodes": values}})
    print(json.dumps({"data": {"node": {"projectItems": {"nodes": items}}}}))
    sys.exit(0)

if "addProjectV2ItemById" in query:
    if scenario.startswith("duplicate"):
        print("gh: Content already exists in this project", file=sys.stderr)
        sys.exit(1)
    if scenario == "api_error":
        print("gh: Resource not accessible by integration", file=sys.stderr)
        sys.exit(1)
    print(json.dumps({"data": {"addProjectV2ItemById": {"item": {"id": "NEW_ITEM"}}}}))
    sys.exit(0)

if "updateProjectV2ItemFieldValue" in query:
    print(json.dumps({"data": {"updateProjectV2ItemFieldValue":
                       {"projectV2Item": {"id": "TARGET_ITEM"}}}}))
    sys.exit(0)

print("Chamada inesperada de gh: " + repr(args), file=sys.stderr)
sys.exit(2)
'''


def apply_script():
    lines = WORKFLOW.read_text(encoding="utf-8").splitlines()
    step = lines.index("      - name: Garantir item no Project e atualizar Status")
    run = lines.index("        run: |", step)
    end = next(i for i in range(run + 1, len(lines)) if lines[i].startswith("      - name:"))
    return textwrap.dedent("\n".join(lines[run + 1:end])) + "\n"


class RoutingRaceTest(unittest.TestCase):
    def run_case(self, scenario, action="labeled"):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            gh = root / "gh"
            gh.write_text(MOCK_GH, encoding="utf-8")
            gh.chmod(0o755)
            event = root / "event.json"
            event.write_text(json.dumps({"action": action}), encoding="utf-8")
            output = root / "output"
            log = root / "gh.log"
            env = os.environ.copy()
            env.update({
                "PATH": f"{root}:{env['PATH']}",
                "MOCK_SCENARIO": scenario,
                "MOCK_LOG": str(log),
                "GITHUB_EVENT_PATH": str(event),
                "GITHUB_OUTPUT": str(output),
                "GITHUB_EVENT_NAME": "issues",
                "ISSUE_REFS_JSON": '[{"owner":"Lumus-IT","name":"protos","number":155}]',
                "PROJECT_ID": "TARGET",
                "STATUS_FIELD_ID": "STATUS_FIELD",
                "STATUS_OPTION_ID": "TRIAGE_OPTION",
                "TARGET_STATUS_NAME": "Triage",
                "SHOULD_UPDATE_STATUS": "true",
                "INPUT_STATUS_READY": "Ready",
                "INPUT_STATUS_IN_PROGRESS": "In-progress",
                "INPUT_STATUS_IN_REVIEW": "In review",
                "INPUT_STATUS_DONE": "Done",
                "INPUT_STATUS_CANCELED": "Canceled",
            })
            result = subprocess.run(["bash"], input=apply_script(), env=env,
                                    text=True, capture_output=True, check=False)
            calls = [json.loads(line) for line in log.read_text(encoding="utf-8").splitlines()]
            outputs = output.read_text(encoding="utf-8") if output.exists() else ""
            return result, calls, outputs

    @staticmethod
    def calls_with(calls, fragment):
        return [call for call in calls if any(fragment in arg for arg in call)]

    def test_duplicate_reuses_item_and_preserves_advanced_status(self):
        result, calls, outputs = self.run_case("duplicate_preserve")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(self.calls_with(calls, "projectItems(first: 100)")), 2)
        self.assertEqual(len(self.calls_with(calls, "addProjectV2ItemById")), 1)
        self.assertFalse(self.calls_with(calls, "updateProjectV2ItemFieldValue"))
        self.assertIn("mantida em In-progress", result.stdout)
        self.assertIn("processed_issue_numbers=155", outputs)

    def test_duplicate_updates_status_on_reused_item(self):
        result, calls, _ = self.run_case("duplicate_update", action="opened")
        self.assertEqual(result.returncode, 0, result.stderr)
        updates = self.calls_with(calls, "updateProjectV2ItemFieldValue")
        self.assertEqual(len(updates), 1)
        self.assertIn("itemId=TARGET_ITEM", updates[0])

    def test_other_api_error_stays_visible(self):
        result, calls, _ = self.run_case("api_error")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Resource not accessible by integration", result.stderr)
        self.assertEqual(len(self.calls_with(calls, "projectItems(first: 100)")), 1)
        self.assertFalse(self.calls_with(calls, "updateProjectV2ItemFieldValue"))

    def test_duplicate_without_visible_item_fails(self):
        result, calls, _ = self.run_case("duplicate_missing")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("item não foi encontrado no Project", result.stdout)
        self.assertEqual(len(self.calls_with(calls, "projectItems(first: 100)")), 2)

    def test_existing_item_does_not_attempt_inclusion(self):
        result, calls, _ = self.run_case("existing")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.calls_with(calls, "addProjectV2ItemById"))
        self.assertEqual(len(self.calls_with(calls, "updateProjectV2ItemFieldValue")), 1)


if __name__ == "__main__":
    unittest.main()
