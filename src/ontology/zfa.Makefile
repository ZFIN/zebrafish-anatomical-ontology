## Customize Makefile settings for zfa
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# zfa-zfin does not use REDUCE to avoid stripping out redundant stage 
# information on terms

# This weird hack is necessary as I cant actually add the import to the edit file
# because ZFIN still uses OBO Edit
$(EDIT_PREPROCESSED): $(SRC)
	$(ROBOT) merge --input $< $(patsubst %, -i %, $(IMPORT_FILES)) \
	convert --format ofn --output $@

zfa-zfin.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed asserted-only --exclude-tautologies structural \
		relax \
		$(SHARED_ROBOT_COMMANDS) annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@

zfa-base.owl: $(EDIT_PREPROCESSED) $(OTHER_SRC) $(IMPORT_FILES)
	$(ROBOT_RELEASE_IMPORT_MODE) \
	reason --reasoner $(REASONER) --equivalent-classes-allowed asserted-only --exclude-tautologies structural --annotate-inferred-axioms false \
	relax $(RELAX_OPTIONS) \
	reduce -r $(REASONER) $(REDUCE_OPTIONS) \
	remove --base-iri http://purl.obolibrary.org/obo/ZFA_ --base-iri http://purl.obolibrary.org/obo/zfa.owl --axioms external --preserve-structure false --trim false \
	remove --term http://purl.obolibrary.org/obo/IAO_0000700 --select ontology \
	$(SHARED_ROBOT_COMMANDS) \
	annotate \
		--link-annotation http://purl.obolibrary.org/obo/IAO_0000700 http://purl.obolibrary.org/obo/ZFA_0100000 \
		--link-annotation http://purl.org/dc/elements/1.1/type http://purl.obolibrary.org/obo/IAO_8000001 \
		--link-annotation http://purl.org/dc/terms/license https://creativecommons.org/licenses/by/3.0/ \
		--annotation http://purl.org/dc/terms/title "Zebrafish Anatomy Ontology (ZFA)" \
		--annotation http://purl.org/dc/terms/description "An ontology of Zebrafish anatomy." \
		--ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@

zfs-base.owl: $(EDIT_PREPROCESSED) $(OTHER_SRC) $(IMPORT_FILES)
	$(ROBOT_RELEASE_IMPORT_MODE) \
	reason --reasoner $(REASONER) --equivalent-classes-allowed asserted-only --exclude-tautologies structural --annotate-inferred-axioms false \
	relax $(RELAX_OPTIONS) \
	reduce -r $(REASONER) $(REDUCE_OPTIONS) \
	remove --base-iri http://purl.obolibrary.org/obo/ZFS_ --base-iri http://purl.obolibrary.org/obo/zfs.owl --axioms external --preserve-structure false --trim false \
	remove --term http://purl.obolibrary.org/obo/IAO_0000700 --select ontology \
	$(SHARED_ROBOT_COMMANDS) \
	annotate \
		--link-annotation http://purl.org/dc/elements/1.1/type http://purl.obolibrary.org/obo/IAO_8000001 \
		--link-annotation http://purl.obolibrary.org/obo/IAO_0000700 http://purl.obolibrary.org/obo/ZFS_0100000 \
		--link-annotation http://purl.org/dc/terms/license https://creativecommons.org/licenses/by/3.0/ \
		--annotation http://purl.org/dc/terms/title "Zebrafish Developmental Stages Ontology (ZFS)" \
		--annotation http://purl.org/dc/terms/description "An ontology of Zebrafish developmental stages." \
		--ontology-iri $(ONTBASE)/$@ annotate -V $(OBOBASE)/zfs/releases/$(VERSION)/$@ --annotation owl:versionInfo $(VERSION) \
		--output $@.tmp.owl && mv $@.tmp.owl $@

zfs.owl: zfa.owl
	$(ROBOT) merge --input $< \
		$(SHARED_ROBOT_COMMANDS) annotate --ontology-iri $(OBOBASE)/$@ \
		annotate -V $(OBOBASE)/zfs/releases/$(VERSION)/$@ --annotation owl:versionInfo $(VERSION) --output $@
