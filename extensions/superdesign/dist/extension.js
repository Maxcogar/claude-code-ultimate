/**
 * superdesign VS Code Extension
 * The 1st Design Agent that lives inside your IDE
 */

const vscode = require('vscode');
const path = require('path');

// Extension activation
function activate(context) {
    console.log('superdesign extension is now active!');

    // Register commands
    registerCommands(context);
    
    // Initialize design agent
    initializeDesignAgent(context);
    
    // Set up UI components
    setupUIComponents(context);
}

function registerCommands(context) {
    // Generate UI Component command
    const generateComponent = vscode.commands.registerCommand('superdesign.generateComponent', async () => {
        const componentName = await vscode.window.showInputBox({
            prompt: 'Enter component name',
            placeHolder: 'Button, Card, Modal, etc.'
        });
        
        if (componentName) {
            await generateUIComponent(componentName);
        }
    });
    
    // Create wireframe command
    const createWireframe = vscode.commands.registerCommand('superdesign.createWireframe', async () => {
        const pageType = await vscode.window.showQuickPick([
            'Landing Page',
            'Dashboard',
            'User Profile',
            'Settings Page',
            'Custom'
        ], {
            placeHolder: 'Select page type for wireframe'
        });
        
        if (pageType) {
            await createPageWireframe(pageType);
        }
    });
    
    // Design system command
    const generateDesignSystem = vscode.commands.registerCommand('superdesign.generateDesignSystem', () => {
        generateProjectDesignSystem();
    });
    
    // AI design chat command
    const openDesignChat = vscode.commands.registerCommand('superdesign.openDesignChat', () => {
        openDesignChatPanel();
    });
    
    context.subscriptions.push(generateComponent, createWireframe, generateDesignSystem, openDesignChat);
}

function initializeDesignAgent(context) {
    // Initialize the design AI agent
    const designAgent = {
        name: 'SuperDesign Agent',
        capabilities: [
            'UI component generation',
            'Wireframe creation',
            'Design system development',
            'Responsive design patterns',
            'Accessibility compliance',
            'Design token management'
        ],
        integrations: [
            'React', 'Vue', 'Angular', 'HTML/CSS',
            'Tailwind CSS', 'Material-UI', 'Ant Design'
        ]
    };
    
    // Store agent reference
    context.globalState.update('designAgent', designAgent);
    
    vscode.window.showInformationMessage('SuperDesign Agent initialized and ready!');
}

async function generateUIComponent(componentName) {
    try {
        // Show progress
        vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: `Generating ${componentName} component...`,
            cancellable: false
        }, async (progress) => {
            progress.report({ increment: 25, message: 'Analyzing requirements...' });
            
            // Simulate component generation logic
            await new Promise(resolve => setTimeout(resolve, 1000));
            progress.report({ increment: 50, message: 'Creating component structure...' });
            
            await new Promise(resolve => setTimeout(resolve, 1000));
            progress.report({ increment: 75, message: 'Adding styling and accessibility...' });
            
            // Generate component template
            const componentCode = generateComponentTemplate(componentName);
            
            // Create new file
            const workspaceEdit = new vscode.WorkspaceEdit();
            const componentPath = vscode.Uri.file(path.join(
                vscode.workspace.workspaceFolders[0].uri.fsPath,
                'src',
                'components',
                `${componentName}.jsx`
            ));
            
            workspaceEdit.createFile(componentPath);
            workspaceEdit.insert(componentPath, new vscode.Position(0, 0), componentCode);
            
            await vscode.workspace.applyEdit(workspaceEdit);
            
            progress.report({ increment: 100, message: 'Component created successfully!' });
            
            // Open the created file
            const document = await vscode.workspace.openTextDocument(componentPath);
            await vscode.window.showTextDocument(document);
        });
        
    } catch (error) {
        vscode.window.showErrorMessage(`Failed to generate component: ${error.message}`);
    }
}

async function createPageWireframe(pageType) {
    try {
        const wireframeContent = generateWireframeTemplate(pageType);
        
        // Create wireframe file
        const workspaceEdit = new vscode.WorkspaceEdit();
        const wireframePath = vscode.Uri.file(path.join(
            vscode.workspace.workspaceFolders[0].uri.fsPath,
            'wireframes',
            `${pageType.toLowerCase().replace(' ', '-')}-wireframe.html`
        ));
        
        workspaceEdit.createFile(wireframePath);
        workspaceEdit.insert(wireframePath, new vscode.Position(0, 0), wireframeContent);
        
        await vscode.workspace.applyEdit(workspaceEdit);
        
        // Open the wireframe
        const document = await vscode.workspace.openTextDocument(wireframePath);
        await vscode.window.showTextDocument(document);
        
        vscode.window.showInformationMessage(`${pageType} wireframe created successfully!`);
        
    } catch (error) {
        vscode.window.showErrorMessage(`Failed to create wireframe: ${error.message}`);
    }
}

function generateProjectDesignSystem() {
    vscode.window.showInformationMessage('Generating design system for your project...');
    
    // This would integrate with the project's existing code to create a cohesive design system
    const designSystemConfig = {
        colors: {
            primary: '#3B82F6',
            secondary: '#64748B', 
            success: '#10B981',
            warning: '#F59E0B',
            error: '#EF4444'
        },
        typography: {
            fontFamily: '"Inter", sans-serif',
            scales: ['xs', 'sm', 'base', 'lg', 'xl', '2xl', '3xl']
        },
        spacing: [4, 8, 12, 16, 20, 24, 32, 40, 48, 64],
        components: []
    };
    
    // Would generate design tokens, component library, etc.
    vscode.window.showInformationMessage('Design system framework created!');
}

function openDesignChatPanel() {
    // Create and show a webview panel for design chat
    const panel = vscode.window.createWebviewPanel(
        'superdesignChat',
        'SuperDesign AI Chat',
        vscode.ViewColumn.Beside,
        {
            enableScripts: true,
            retainContextWhenHidden: true
        }
    );
    
    panel.webview.html = getChatWebviewContent();
    
    // Handle messages from the webview
    panel.webview.onDidReceiveMessage(
        message => {
            switch (message.command) {
                case 'designRequest':
                    handleDesignRequest(message.text, panel);
                    break;
            }
        }
    );
}

function setupUIComponents(context) {
    // Set up additional UI components, status bar items, etc.
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Right, 100);
    statusBarItem.text = "$(paintcan) SuperDesign";
    statusBarItem.tooltip = "Click to open SuperDesign commands";
    statusBarItem.command = 'superdesign.openDesignChat';
    statusBarItem.show();
    
    context.subscriptions.push(statusBarItem);
}

// Template generators
function generateComponentTemplate(componentName) {
    return `import React from 'react';
import PropTypes from 'prop-types';
import './styles/${componentName}.css';

/**
 * ${componentName} Component
 * Generated by SuperDesign AI Agent
 */
const ${componentName} = ({ children, className, ...props }) => {
  return (
    <div className={\`${componentName.toLowerCase()} \${className || ''}\`} {...props}>
      {children}
    </div>
  );
};

${componentName}.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string,
};

${componentName}.defaultProps = {
  children: null,
  className: '',
};

export default ${componentName};
`;
}

function generateWireframeTemplate(pageType) {
    const wireframes = {
        'Landing Page': `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Landing Page Wireframe</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .wireframe { background: white; max-width: 1200px; margin: 0 auto; padding: 20px; }
        .section { border: 2px dashed #ccc; margin: 20px 0; padding: 20px; text-align: center; }
        .header { background: #e0e0e0; }
        .hero { background: #f0f0f0; min-height: 300px; }
        .features { background: #f8f8f8; }
        .footer { background: #e0e0e0; }
    </style>
</head>
<body>
    <div class="wireframe">
        <div class="section header">
            <h2>Header Navigation</h2>
            <p>Logo | Menu Items | CTA Button</p>
        </div>
        <div class="section hero">
            <h1>Hero Section</h1>
            <p>Main headline and value proposition</p>
            <p>[Call to Action Button]</p>
        </div>
        <div class="section features">
            <h2>Features Section</h2>
            <p>Feature 1 | Feature 2 | Feature 3</p>
        </div>
        <div class="section footer">
            <h2>Footer</h2>
            <p>Links | Contact | Social Media</p>
        </div>
    </div>
</body>
</html>`,
        'Dashboard': `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Wireframe</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f5f5f5; }
        .dashboard { display: grid; grid-template-areas: "sidebar header" "sidebar main"; grid-template-columns: 250px 1fr; grid-template-rows: 60px 1fr; height: 100vh; }
        .sidebar { grid-area: sidebar; background: #2d3748; color: white; padding: 20px; }
        .header { grid-area: header; background: white; padding: 20px; border-bottom: 1px solid #e0e0e0; }
        .main { grid-area: main; padding: 20px; overflow-y: auto; }
        .widget { background: white; border: 2px dashed #ccc; margin: 10px 0; padding: 20px; text-align: center; }
    </style>
</head>
<body>
    <div class="dashboard">
        <div class="sidebar">
            <h3>Navigation</h3>
            <ul style="list-style: none; padding: 0;">
                <li>Dashboard</li>
                <li>Analytics</li>
                <li>Users</li>
                <li>Settings</li>
            </ul>
        </div>
        <div class="header">
            <h2>Dashboard Header</h2>
            <p>User Profile | Search | Notifications</p>
        </div>
        <div class="main">
            <div class="widget">
                <h3>Key Metrics Widget</h3>
                <p>Charts and Statistics</p>
            </div>
            <div class="widget">
                <h3>Recent Activity</h3>
                <p>Activity List</p>
            </div>
            <div class="widget">
                <h3>Quick Actions</h3>
                <p>Action Buttons</p>
            </div>
        </div>
    </div>
</body>
</html>`
    };
    
    return wireframes[pageType] || wireframes['Landing Page'];
}

function getChatWebviewContent() {
    return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SuperDesign AI Chat</title>
        <style>
            body {
                font-family: var(--vscode-font-family);
                background: var(--vscode-editor-background);
                color: var(--vscode-editor-foreground);
                margin: 0;
                padding: 20px;
                height: 100vh;
                display: flex;
                flex-direction: column;
            }
            .chat-container {
                flex: 1;
                overflow-y: auto;
                padding: 10px;
                border: 1px solid var(--vscode-panel-border);
                border-radius: 4px;
                margin-bottom: 10px;
            }
            .input-container {
                display: flex;
                gap: 10px;
            }
            input {
                flex: 1;
                padding: 8px;
                background: var(--vscode-input-background);
                border: 1px solid var(--vscode-input-border);
                color: var(--vscode-input-foreground);
                border-radius: 4px;
            }
            button {
                padding: 8px 16px;
                background: var(--vscode-button-background);
                color: var(--vscode-button-foreground);
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .message {
                margin: 10px 0;
                padding: 10px;
                border-radius: 8px;
            }
            .user-message {
                background: var(--vscode-inputOption-activeBackground);
                margin-left: 20px;
            }
            .ai-message {
                background: var(--vscode-textCodeBlock-background);
                margin-right: 20px;
            }
        </style>
    </head>
    <body>
        <h2>SuperDesign AI Assistant</h2>
        <div class="chat-container" id="chatContainer">
            <div class="message ai-message">
                <strong>SuperDesign:</strong> Hi! I'm your design assistant. I can help you create UI components, wireframes, and design systems. What would you like to design today?
            </div>
        </div>
        <div class="input-container">
            <input type="text" id="messageInput" placeholder="Ask me to create a component, wireframe, or design pattern...">
            <button onclick="sendMessage()">Send</button>
        </div>
        
        <script>
            const vscode = acquireVsCodeApi();
            
            function sendMessage() {
                const input = document.getElementById('messageInput');
                const message = input.value.trim();
                
                if (message) {
                    addMessage('user', message);
                    input.value = '';
                    
                    vscode.postMessage({
                        command: 'designRequest',
                        text: message
                    });
                }
            }
            
            function addMessage(sender, text) {
                const container = document.getElementById('chatContainer');
                const messageDiv = document.createElement('div');
                messageDiv.className = \`message \${sender}-message\`;
                messageDiv.innerHTML = \`<strong>\${sender === 'user' ? 'You' : 'SuperDesign'}:</strong> \${text}\`;
                container.appendChild(messageDiv);
                container.scrollTop = container.scrollHeight;
            }
            
            document.getElementById('messageInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });
        </script>
    </body>
    </html>
    `;
}

function handleDesignRequest(message, panel) {
    // Simulate AI response
    setTimeout(() => {
        let response = "I'd be happy to help you with that design request! ";
        
        if (message.toLowerCase().includes('component')) {
            response += "I can generate React components, Vue components, or plain HTML/CSS. Would you like me to create a specific component for you?";
        } else if (message.toLowerCase().includes('wireframe')) {
            response += "I can create wireframes for landing pages, dashboards, forms, and more. What type of page are you designing?";
        } else if (message.toLowerCase().includes('design system')) {
            response += "I can help you create a comprehensive design system with colors, typography, spacing, and component guidelines.";
        } else {
            response += "I can help with UI components, wireframes, design systems, and responsive layouts. What specific design challenge are you facing?";
        }
        
        panel.webview.postMessage({
            command: 'addAIMessage',
            text: response
        });
    }, 1000);
}

// Extension deactivation
function deactivate() {
    console.log('superdesign extension is now deactivated.');
}

module.exports = {
    activate,
    deactivate
};
