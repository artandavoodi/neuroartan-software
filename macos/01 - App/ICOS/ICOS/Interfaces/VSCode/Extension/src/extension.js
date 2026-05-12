const fs = require("fs");
const os = require("os");
const path = require("path");
const vscode = require("vscode");

function bridgeFilePath() {
  return path.join(os.homedir(), "Library", "Application Support", "ICOS", "editor_bridge", "active-editor-state.json");
}

function workspaceRootFor(document) {
  const workspaceFolder = vscode.workspace.getWorkspaceFolder(document.uri);
  if (workspaceFolder) {
    return workspaceFolder.uri.fsPath;
  }
  return path.dirname(document.uri.fsPath);
}

function publishActiveFile() {
  const editor = vscode.window.activeTextEditor;
  if (!editor || editor.document.uri.scheme !== "file") {
    vscode.window.setStatusBarMessage("ICOS: no local active file to publish", 2500);
    return;
  }

  const targetPath = bridgeFilePath();
  fs.mkdirSync(path.dirname(targetPath), { recursive: true });
  fs.writeFileSync(targetPath, JSON.stringify({
    editor: "VS Code",
    activeFilePath: editor.document.uri.fsPath,
    workspaceRoot: workspaceRootFor(editor.document),
    updatedAt: new Date().toISOString()
  }, null, 2));
  vscode.window.setStatusBarMessage(`ICOS: published ${path.basename(editor.document.uri.fsPath)}`, 2500);
}

function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand("icosEditorBridge.publishActiveFile", publishActiveFile),
    vscode.window.onDidChangeActiveTextEditor(() => publishActiveFile()),
    vscode.workspace.onDidOpenTextDocument(() => publishActiveFile()),
    vscode.workspace.onDidSaveTextDocument(() => publishActiveFile())
  );

  publishActiveFile();
}

function deactivate() {}

module.exports = {
  activate,
  deactivate
};
