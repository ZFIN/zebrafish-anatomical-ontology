## Customize Makefile settings for zfa
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# zfa-zfin does not use REDUCE to avoid stripping out redundant stage 
# information on terms
zfa-zfin.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed asserted-only --exclude-tautologies structural \
		relax \
		$(SHARED_ROBOT_COMMANDS) annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@
