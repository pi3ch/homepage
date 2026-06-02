.PHONY: serve new

serve:
	hugo server -D

new:
	@read -p "Post slug (e.g. my-new-post): " slug; \
	hugo new content blog/$$slug.md
