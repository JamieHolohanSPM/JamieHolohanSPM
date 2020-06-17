
function wikiLoad() {
  var url = window.location.pathname;
  var filename = decodeURIComponent(url.substring(url.lastIndexOf('/')+1));
  parentNode = document.getElementById("main-menu");
  identifyShownPages(navigation, filename);
  addMenuItems(parentNode, navigation, 0, filename);
}

function identifyShownPages(pages,filename) {
  var thisBranchOpen=false;
  for (var name in pages) {
    var page = pages[name];
    if (!thisBranchOpen) { // if it's open it's open
      var testFilename = page.file.substring(page.file.lastIndexOf('/')+1);
      if (testFilename==filename) {
        page.selected=true;
        thisBranchOpen=true;
        if (page.hasOwnProperty("children")) {
          page.expanded = true;
          showBranch(page.children);
        }
      } else if (page.hasOwnProperty("children")) {
        var childOpen=identifyShownPages(page.children,filename);
        page.expanded = childOpen;
        thisBranchOpen = thisBranchOpen || childOpen;
      }
    }
  }
  if (thisBranchOpen) { // open peers
    showBranch(pages);
  }
  return thisBranchOpen;
}

function showBranch(pages) {
  for (var name in pages) {
    pages[name].shown=true;
  }
}

function addMenuItems(parentNode, pages, level) {

  for (var name in pages) {
    var page = pages[name];
    var node = createListItem(name, page, level);
    parentNode.appendChild(node);
    if (page.hasOwnProperty("children")) {
      addMenuItems(parentNode, page.children, level+1);
    }
  }
}

function createListItem(text, page, level) {
  var cname = "menu-item-"+level;

  var node = document.createElement("li");
  node.classList.add(cname);
  node.level = level;

  var expandnode = document.createElement("span");
  expandnode.appendChild(document.createTextNode(""));
  expandnode.classList.add("expander");
  if (page.hasOwnProperty("children")) {
    var expandText = page.expanded ? '-' : '+';
    expandnode.appendChild(createAnchor(expandText, page));
  }
  node.appendChild(expandnode);
  
  node.appendChild(createAnchor(text, page));

  if (!page.shown && level>0) {
    node.classList.add("hidden");
  }
  if (page.selected) {
    node.classList.add("menu-selected");
  }

  return node;
}

function createAnchor(text, page) {
  var anode = document.createElement("a");
  anode.href = toRoot + page.file;
  anode.appendChild(document.createTextNode(text));
  return anode;
}
