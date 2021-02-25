# sparql-prov-watdiv

Provenance experiments based on the WatDiv benchmark

## Setup LXD

## Setup ruby

```bash
sudo apt install -y \
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
  zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
  pigz
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
. ~/.bashrc
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 3.0.0
```

# Setup TripleProv

```
sed -i -e 's/~galuc/galuc/g' -e 's/ns#type>/ns\/type>/' 10M/watdiv.10M-namedgraphs.nt
sed -i -e 's/~galuc/galuc/g' -e 's/ns#type>/ns\/type>/' 100M/watdiv.100M-namedgraphs.nt
```