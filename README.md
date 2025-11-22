normal geth -> can't sync at 1920000 cuz PoS beacon <br>
alternate using core-geth <br>
<br>

local tested. <br>
etc hardfork. full synced. cpu mining level 1. chainID change. <br>
<br>
node A : etc 1910000 -> 1910400 <br>
node B : node A Full synced <br>
node C : node A snapshot synced <br>

<br>
<br>
<br>
wget https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz 
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

go version
<br>

