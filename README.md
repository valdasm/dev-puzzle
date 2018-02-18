
[![Build Status](https://travis-ci.org/valdasm/dev-puzzle.svg?branch=master)](https://travis-ci.org/valdasm/dev-puzzle)

## DEV PUZZLE

## EXECUTE
* PREVIEW - rake preview
* BUILD - rake build 
* CHECK LINKS (requires page to be already running) - rake check_links 

## CONTRIBUTE
There are two ways:
1. Add new services and mappings - dive into db folder and modify json files
2. Contribute to the whole page

## BACKLOG
[ ] Add tags page
[ ] Populate services with tags, use this for a broader search; As of know people without Azure knowledge can't find correct services
[ ] Compare page AWS, Azure, Google
[ ] Rename services into cloud?
[ ] Filter based on cloud provider 
[ ] Rename 

## TODO
[ ] Landing page (nice images, link to WHY post, example of mappings)
[ ] Services analytics-jupyter; analytics-python don't have corresponding services, thus are missing in view.
[ ] Add json data validation test; execute on travis build
[ ] Description and links for all services
[ ] There should be at least one mapping for every service

## Done
[x] Setup custom domain, build, deployment, HTTPS

## Dismissed
[ ] Change permalink for blog posts. REASON: Failing breadcrumbs + no actual value for a reader. Date is visible now.
