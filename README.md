
[![Build Status](https://travis-ci.org/valdasm/dev-puzzle.svg?branch=master)](https://travis-ci.org/valdasm/dev-puzzle)

# EXECUTE
* PREVIEW - rake preview
* BUILD - rake build 
* CHECK LINKS (requires page to be already running) - rake check_links 

# CONTRIBUTE
There are two ways:
1. Add new services and mappings - dive into db folder and modify json files
2. Contribute to the whole page

# WORK ITEMS

### BACKLOG
* Add tags page for cloud services. Tag cloud
* Populate services with tags, use this for a broader search; As of know people without Azure knowledge can't find correct services
* Compare page AWS, Azure, Google
* Rename services into cloud?
* Filter based on cloud provider 

### TODO

* Services analytics-jupyter; analytics-python don't have corresponding services, thus are missing in view.
* Add json data validation test; execute on travis build
* Description and links for all services
* There should be at least one mapping for every service
* Landing page (nice images, link to WHY post, example of mappings)
* D3.JS relationships graph
* Create instruction how to contribute (service, mappings files)

### Doing
* Blog post Welcome To Dev Puzzle
* Listing all services, Azure first and add corresponding AWS

### Done
[x] Message when mappings are not available.

[x] Fix templates to use template structure. Currently you use plain structure without indentations.

[x] Setup custom domain, build, deployment, HTTPS

### Dismissed
* Change permalink for blog posts collection: REASON: Failing breadcrumbs + no actual value for a reader. Date is visible now in URL.
