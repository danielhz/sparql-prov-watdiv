# Provenance for SPARQL queries via Query Rewiring: WatDiv benchmark

This repository contains the source code that defines an experiment to
show the overhead of a method to compute how-provenance for SPARQL
queries via query rewiriting.  This experiment is based on the WatDiv
benchmark.

## Preparing the environment

In this experiment we need three tools: LXD to install engines inside
containers, Ruby to automatize the execution of benchmarks, and
TripleProv.

### Setup LXD

We use LXD containers to facilitate the reproducibility of this
experiment.  Each of the multiple database instances is enclosed into
a separate container.

In our experiment we use a machine with Ubuntu 18.04 and install LXD
using `snap` (the recomended way these days).  Instructions to setup
LXD can be found in the [LXD
documentation](https://linuxcontainers.org/lxd/getting-started-cli/#installation).

### Setup Ruby

We use the Ruby programing language to automatize the execution of the
experiments.  We use the version 3.0.0 that can be installed with
`rbenv` and `rbenv-install`.  The following commands install Ruby 3.0.0.

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

After installing Ruby 3.0.0 it is needed to install some Ruby
packages.  This is done by running `bundle install` inside the root
folder of this repository.

### Setup TripleProv

We copy the [code](https://github.com/MarcinWylot/tripleprov_demo)
developed by Marcyn Wylot to the folder `tripleprov`.  The file
`tripleprov/src/diplodocus.cpp` was modified to acelerate the
exectution of the benchmark.  In the orginal demo, the dataset is
loaded to RAM each time a query is executed.  Instead, we load the
dataset once for the execution of all qeries.

## Preparing the data

We load the data from the official WatDiv website into the folder
`datasets`.  Then, we run the script `scripts/reify.rb` to generate
the reified versions of the datasets.

```bash
cd datasets

wget https://dsg.uwaterloo.ca/watdiv/watdiv.10M.tar.bz2
tar -xjf watdiv.10M.tar.bz2

rm watdiv.10M.tar.bz2
rm saved.txt

cat watdiv.10M.nt | ../scripts/reify.rb namedgraphs > watdiv.10M-namedgraphs.nt
cat watdiv.10M.nt | ../scripts/reify.rb rdf > watdiv.10M-rdf.nt
cat watdiv.10M.nt | ../scripts/reify.rb wikidata > watdiv.10M-wikidata.nt
```

The script above generates the files
`datasets/watdiv.10M-namedgraphs.nt`, `datasets/watdiv.10M-rdf.nt`,
and `datasets/watdiv.10M-wikidata.nt`, corresponding to the datasets
reified using the named graphs, standard, and Wikidata reification
schemes.  We can repeat the same commands for the datasets of 100 and
1000 millions of triples (replacing 10M by 100M and 1000M).

### Fix the the data for TripleProv

The TripleProv implementation have issues with the symbols `~` and
`#`.  These symbols are removed from the dataset with the following
commands:

```
sed -i -e 's/~galuc/galuc/g' -e 's/ns#type>/ns\/type>/' 10M/watdiv.10M-namedgraphs.nt
sed -i -e 's/~galuc/galuc/g' -e 's/ns#type>/ns\/type>/' 100M/watdiv.100M-namedgraphs.nt
sed -i -e 's/~galuc/galuc/g' -e 's/ns#type>/ns\/type>/' 1000M/watdiv.100M-namedgraphs.nt
```

## Generate the queries

The queries are generated with the follwing command:

```
rake queries
```

## Run the benchmark

```
rake bench
```
