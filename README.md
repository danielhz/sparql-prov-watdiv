# Provenance for SPARQL queries via Query Rewiring: WatDiv benchmark

This is the source code repository of a experiment to study a method
for computing how-provenance for SPARQL via query rewriting.  This is
experiment is based on the WatDiv benchmark that is a well-known
synthetic benchmark that defines an RDF dataset with varying
structural characteristics and selectivity classes.

## Structure of this repository

```
datasets       # The RDF data
lib            # Libraries required for the experiments
params         # Parameters to fill the query templates
queries        # Queries
rakelib        # Libraries required for experiment tasks
results        # Where results are saved
scripts        # Scripts
tasks_status   # Where we save the status of tasks
tripleprov     # The TripleProv code
```

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
`tripleprov/src/diplodocus.cpp` was modified to speedup the execution
of the benchmark.  In the orginal demo, the dataset is loaded to RAM
each time a query is executed.  Instead, we load the dataset once for
the execution of all queries.

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

### Loading the data in a triple store

So far, we have created a dataset for each reification scheme.  We
next explain how to load each of these datasets in each triple store
engine.  We consider two triple store engines: Fuseki 3 (using TDB1)
and Virtuoso 7.

Datasets are loaded using [rake tasks](https://github.com/ruby/rake)
that are defined in `rakelib`.

Before loading the datasets, we need to create a container for each
engine.

```bash
rake task_status/done_create_fuseki_3_container
rake taks_status/done_create_virtuoso_7_container
```

These tasks above create two containers that serve as base to create
the container where to load each dataset.  The following tasks do the
load the datasets in copies of the aforementioned containers.  The
loading of datasets assumes that datasets are in the folder `datasets`
(recall that we create the reified versions of the WatDiv datasets on
this folder).

```
rake task_status/done_create_watdiv_1000M_namedgraphs_virtuoso_7_container
rake task_status/done_create_watdiv_1000M_rdf_virtuoso_7_container
rake task_status/done_create_watdiv_1000M_wikidata_virtuoso_7_container
rake task_status/done_create_watdiv_100M_namedgraphs_fuseki_3_container
rake task_status/done_create_watdiv_100M_namedgraphs_virtuoso_7_container
rake task_status/done_create_watdiv_100M_rdf_fuseki_3_container
rake task_status/done_create_watdiv_100M_rdf_virtuoso_7_container
rake task_status/done_create_watdiv_100M_wikidata_fuseki_3_container
rake task_status/done_create_watdiv_100M_wikidata_virtuoso_7_container
rake task_status/done_create_watdiv_10M_namedgraphs_fuseki_3_container
rake task_status/done_create_watdiv_10M_namedgraphs_virtuoso_7_container
rake task_status/done_create_watdiv_10M_rdf_fuseki_3_container
rake task_status/done_create_watdiv_10M_rdf_virtuoso_7_container
rake task_status/done_create_watdiv_10M_wikidata_fuseki_3_container
rake task_status/done_create_watdiv_10M_wikidata_virtuoso_7_container
```

### Fix the the data for TripleProv

We do not create a container for the TripleProv engine.  Instead we
use the folder `tripleprov/dataset` to make the data accessible for
TripleProv.

The TripleProv implementation have issues with the symbols `~` and
`#`.  We simply replace these symbols for suitable supported symbols.
For instance, to prepare the dataset of 100 million triples for
TripleProv, we execute the following commands:

```
cp 10M/watdiv.10M-namedgraphs.nt tripleprov/dataset
sed -i -e 's/~galuc/galuc/g' -e 's/ns#type>/ns\/type>/' \
    tripleprov/dataset/watdiv.100M-namedgraphs.nt
```

Observe that TripleProv only supports the named graph reification
scheme.

## Generate the queries

The queries are generated with the follwing command:

```
rake queries
```

## Run the benchmark

```
rake bench
```
