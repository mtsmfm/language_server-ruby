FROM selenium/standalone-chrome-debug:3.7.1

USER root
RUN apt-get update && apt-get install apt-transport-https -y && \
  wget https://packages.microsoft.com/keys/microsoft.asc -q -O - | gpg --dearmor > microsoft.gpg && \
  mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
  apt-get update && apt-get install code netcat -y

USER seluser

RUN wget https://mtsmfm.gallery.vsassets.io/_apis/public/gallery/publisher/mtsmfm/extension/ruby-lsc/0.1.1/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage -O /tmp/ruby-lsc.vsix && \
  /usr/bin/code --install-extension /tmp/ruby-lsc.vsix && \
  rm /tmp/ruby-lsc.vsix

COPY vscode_wrapper /opt/vscode_wrapper
