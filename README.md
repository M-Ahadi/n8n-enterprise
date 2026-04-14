# n8n Enterprise Unlocked 🚀

A modified version of [n8n](https://github.com/n8n-io/n8n) workflow automation platform with **all enterprise features unlocked** and **no license restrictions**.

## ⚡ What's Unlocked

This version bypasses all license checks and enables the complete suite of n8n enterprise features:

### 🔐 Authentication & Security
- ✅ **LDAP Authentication** - Enterprise directory integration
- ✅ **SAML SSO** - Single sign-on capabilities
- ✅ **Advanced User Management** - Unlimited users and roles
- ✅ **External Secrets Management** - Enterprise secrets integration

### 📊 Advanced Features  
- ✅ **API Access** - Full REST API without restrictions
- ✅ **Advanced Workflows** - Unlimited active workflows
- ✅ **Variables Management** - Unlimited environment variables
- ✅ **Workflow History** - Complete execution history and versioning
- ✅ **Team Projects** - Unlimited project collaboration
- ✅ **Source Control** - Git integration for workflows

### 🤖 AI & Analytics
- ✅ **AI Assistant** - Unlimited AI credits and features
- ✅ **Insights & Analytics** - Full execution analytics and monitoring
- ✅ **Log Streaming** - Advanced monitoring capabilities

### 🔧 Development & Customization
- ✅ **Community Nodes** - Install any community packages
- ✅ **Custom Node Development** - Full development environment

## 🛠️ Installation & Setup

### Prerequisites
- Linux OS
- Docker


### Quick Start
The lastest patch is available in [GitHub docker registry](https://ghcr.io/M-Ahadi/n8n-enterprise) or can be created as below:

1. **Clone the repository**
   ```bash
   git clone https://github.com/M-Ahadi/n8n-enterprise.git
   cd n8n-enterprise
   ```

2. **Configure the release version**

    Edit `docker-compose_build.yml` and set the desired n8n release in the `RELEASE` build argument (default is `1.117.2`).


3. **Build the project**
   ```bash
   docker compose -f docker-compose_build.yml up
   ```

4. **Configure .env file**

    Copy .env_sample to .env file and configure it based on your requirements.

   ```bash
   cp .env_sample .env
   ```
   

5. **Start n8n**
   ```bash
   docker compose up -d
   ```

6. **Access n8n**

    Open your browser to `http://localhost:5678` or `https://{subdomain}.{domain}`


7. **Activation**
   
   Request a Community edition license after login, this will be evaluated as Enterprise license.

## 🔧 Technical Implementation

### Modified Components
This patch is based on the mether presented in [n8n-enterprise-unlocked](https://github.com/Abdulazizzn/n8n-enterprise-unlocked)

## 🚨 Important Notes

### Legal Considerations
- This is for **educational and development purposes only**
- Please respect n8n's [license terms](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) for production use
- Consider purchasing a legitimate enterprise license for commercial deployments

### Production Usage
- Test thoroughly before production use
- Monitor for any unexpected behavior
- Keep backups of your workflows and data

### Updates
- This version is based on n8n 1.117.2
- Future updates will require re-applying the license bypasses

## 📋 Feature Verification

After installation, verify that enterprise features are enabled:

1. **Check License Status**: No license warnings should appear
2. **LDAP/SAML**: Authentication options available in settings
3. **API Access**: Full API endpoints accessible
4. **User Management**: Unlimited user creation
5. **Variables**: Environment variables management available
6. **Workflow History**: Version history accessible
7. **AI Features**: AI assistant available without credit limits

## 🤝 Contributing

This is a community fork focused on educational purposes. For the official n8n project:
- Visit [n8n.io](https://n8n.io)
- Official repository: [github.com/n8n-io/n8n](https://github.com/n8n-io/n8n)

## 📄 License

This project maintains the same license structure as the original n8n:
- **n8n core**: [Apache 2.0 with Commons Clause](https://github.com/n8n-io/n8n/blob/master/LICENSE.md)
- **n8n Enterprise**: Enterprise features unlocked for educational use

## ⚠️ Disclaimer

This modified version is provided "as is" for educational and development purposes. The maintainers are not responsible for any issues arising from its use. Please use responsibly and consider supporting the original n8n project.

---

**Original n8n Project**: [n8n.io](https://n8n.io) | [GitHub](https://github.com/n8n-io/n8n)

**Modified by**: Community contributors for educational purposes