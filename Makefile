publish: clean build
	asciibinder package
	mv _package/community docs

publish-github: publish
	[[ -n "$${GITHUB_TOKEN}" ]]
	git remote github git@github.com:kubevirt/user-guide.git
	git config --global user.email "travis@travis-ci.org"
	git config --global user.name "Travis CI"
	#commit_website_files()
	git add docs/
	git commit --message "Travis build: $$TRAVIS_BUILD_NUMBER"
	#upload_files()
	git remote add origin-pages https://$${GITHUB_TOKEN}@github.com/kubevirt/user-guide.git
	git push --set-upstream origin-pages master

clean:
	asciibinder clean
	rm -rf docs

build:
	asciibinder build -l debug

find-unref:
	# Ignore _*.md files
	bash -c 'comm -23 <(find . -regex "./[^_].*\.adoc" | cut -d / -f 2- | sort) <(grep -hRo "[a-zA-Z/:.-]*\.adoc" | sort -u)'

spellcheck:
	for FN in $$(find . -name \*.adoc); do \
	aspell --personal=.aspell.en.pws --lang=en --encoding=utf-8 list <$$FN ; \
	done | sort -u

test:
	test "$$(make -s find-unref) -eq 0"
