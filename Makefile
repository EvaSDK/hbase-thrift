SRCDIR = hbase
GENDIR = build/tmp
SCRIPTDIR = scripts
REFERENCE = refs/tags/rel/0.20.4
INTERFACE = https://gitbox.apache.org/repos/asf?p=hbase.git;a=blob_plain;f=src/java/org/apache/hadoop/hbase/thrift/Hbase.thrift;hb=$(REFERENCE)

all: $(SRCDIR) $(SCRIPTDIR)/Hbase-remote

egg: all
	python setup.py bdist_egg

sdist: all
	python setup.py sdist

$(SRCDIR)/Hbase-remote: $(SRCDIR)
$(SRCDIR): $(GENDIR)/gen-py
	mkdir -p $@
	cp -R $^/hbase/*.py $@

$(SCRIPTDIR)/Hbase-remote: $(GENDIR)/gen-py
	mkdir -p $(SCRIPTDIR)
	cp -R $^/hbase/Hbase-remote $@

$(GENDIR)/gen-py: Hbase.thrift
	-mkdir -p $(GENDIR)
	thrift -o $(GENDIR) -gen py:new_style=True $^

update:
	curl -fsS -o Hbase.thrift "$(INTERFACE)"

clean:
	rm -rf $(GENDIR) $(SRCDIR) $(SCRIPTDIR) gen-* build dist *.egg-info
