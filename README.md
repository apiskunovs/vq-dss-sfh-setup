# vq-dss-sfh-setup
Scripts to setup ViziQuer, DataShapeServer and SPARQLforHumans - all in one go.
- ViziQuer branch `instance-autocompletion` = https://github.com/LUMII-Syslab/viziquer/tree/instance-autocompletion
- DataShapeServer branch `main` = https://github.com/LUMII-Syslab/data-shape-server 
- SPARQLforHumans branch `feature/instance-autocompletion`= https://github.com/apiskunovs/SPARQLforHumans/tree/feature/instance-autocompletion


# Setup

required command line utilities:
- npm
- git
- xcopy
- dotnet
- powershell --> Expand-Archive
- meteor (all except this one are checked by script `check.requirements.bat`)

1. Check if majority of necessary commands are available on the system. !!! `meteor` is not checked
```bash
check.requirements.bat
```

2. Download all git repositories, build and install dependencies. Takes a minute or so depending on speed of the network at hands
```bash
setup.bat
```

3. For this step support from developers of data-shape-server will be needed. The special access has to be granted and set int `.env` file
```bash
START /W notepad.exe data-shape-server\server\.env
```

4. Download Wikidata dump (~6h)
```bash
download.wikidata.dump.bat
```

5. Process dump (~60 hours)
```bash
# for simplicity do in "SparqlForHumans.CLI" folder
cd SPARQLforHumans/SPARQLforHumans.CLI

# filter data. Takes ~7.5h.
# Not all information will be needed for our solution. This will produce filtered content and will
# create another document *.filterAll.gz
dotnet run -- -i ../../data/wikidata/latest-truthy.nt.gz -f 

# sort data. with 16 parallel process it takes around 3h. With 8 processes ~5h.
# !!! be aware that GZIP tool is expected here. Originally it was offered to be install along with
# GIT SDK and, but in practice the same tool potentially can be used from any Linux/Unix env (WSL 
# on Windows). Recommended sort command is provided as a result of filtering. creates new file
# *.filterAll-Sorted.gz
gzip -dc latest-truthy.filterAll.gz | LANG=C sort -S 200M --parallel=16 -T /tmp --compress-program=gzip | gzip > latest-truthy.filterAll-Sorted.gz

# build entity and property index. It takes ~35h and ~2h accordingly
# now indexing command supports BaseFolder configurability (-b <path>). by default it is set to
# "%userprofile%\SparqlForHumans". This path will be required for server configuration to look 
# indexes into. REMARK: both indexes are expected to be in the same BaseFolder.
dotnet run -- -i latest-truthy.filterAll-Sorted.gz -e 
dotnet run -- -i latest-truthy.filterAll-Sorted.gz -p

# ... OR with BaseFolder specified if default one is not ok
# dotnet run -- -i latest-truthy.filterAll-Sorted.gz -e -b ".\Wikidata"
# dotnet run -- -i latest-truthy.filterAll-Sorted.gz -p -b ".\Wikidata"
```

# Running

1. Run all environments. After 15 seconds ViziQuer page will open up in default web-browser app. User: admin@admin.com ; Password: admin
```bash
run.bat
```
