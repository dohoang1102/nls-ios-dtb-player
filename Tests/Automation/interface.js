#import "tuneup/tuneup.js"

test("Bookshelf", function(target, app) {
    mainWindow = app.mainWindow();
    nav = mainWindow.navigationBar();

    if (target.isDeviceiPhone()) {
        assertEquals("Settings", nav.leftButton().name());
        assertEquals("Edit", nav.rightButton().name());
    }
     target.captureScreenWithName("Bookshelf");
});


test("Catalog", function(target, app) {
     mainWindow = app.mainWindow();
     target.captureScreenWithName("hello");
     
     target.captureRectWithName({origin:{x:100,y:100}, size:{width:50, height:150}}, "rect");
     
     test("Catalog Details", function(target, app) {
          target.captureScreenWithName("hello2");
    });
});
