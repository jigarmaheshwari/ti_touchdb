
var currentView = 'by_author';

var books = Alloy.createCollection("Book");
books.on('fetch', function(e) {
  $.tableView.refresh(books);
});

$.tableView.refresh = function(collection) {
  var data = [];
  var section = null;
  collection.each(function(book) {
    var groupProperty;
    if (currentView === 'by_author') {
      groupProperty = book.get('author');
    }
    else if (currentView === 'by_published') {
      groupProperty = book.get('published')[0];
    }
    
    if (!section || section.headerTitle !== groupProperty) {
      if (section) {
        data.push(section);
      }
      section = Ti.UI.createTableViewSection({
        headerTitle: groupProperty
      });
    }
    
    var row = Ti.UI.createTableViewRow({
      title: book.get('title')
    });
    section.add(row);
  });
  data.push(section); // last section
  
  this.setData(data);
};

function loadBookList() {
  books.fetch({ view: currentView });
}

function changeGrouping(e) {
  if (OS_ANDROID) {
    if (e.source.id === 'authorSwitch') {
      if (e.source.value) {
        currentView = 'by_author';
      }
      $.publishedSwitch.value = !e.source.value;
    }
    else if (e.source.id === 'publishedSwitch') {
      if (e.source.value) {
        currentView = 'by_published';
      }
      $.authorSwitch.value = !e.source.value;
    }
  }
  else if (OS_IOS) {
    switch (e.index) {
      case 0:
        currentView = 'by_author';
        break;
      case 1:
        currentView = 'by_published';
        break;
    }
  }
  loadBookList();
}
