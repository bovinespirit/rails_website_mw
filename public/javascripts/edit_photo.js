//
// Edit_Photo Javascript functions
// Copyright (C) Matthew West 2006 - 2007
//
var EditPhotoForm = {
  last_text_preview: {},
  last_title_slug: '',
  // Initialize the page...
  init : function(mode) {
    this.mode = mode;
    if(mode == 'new') {
      this.last_title_slug = $('photo_title').value.toSlug();
      Event.observe('photo_title', 'blur', EditPhotoForm.title_updated_aggressive);
    } else {
      Event.observe('photo_title', 'blur', EditPhotoForm.title_updated);
    }
    $('photo_title').focus();
    Hide.these(
      'photo_preview',
      'image_sizes'
    );
  },
  // For use when updating an existing page...
  title_updated : function() {
    slug = $('photo_slug');
    if(slug.value == "") {
      title = $('photo_title');
      slug.value = title.value.toSlug();
    }
  },
  // For use when creating a new page...
  title_updated_aggressive : function() {
    slug = $('photo_slug');
    title = $('photo_title');
    if(slug.value == "" || slug.value == this.last_title ) {
      slug.value = title.value.toSlug();
    }
    this.last_title = slug.value;
  },
  toggle_images : function(anchor) {
    if(anchor.firstChild.nodeValue == "See Images") {
      Show.these(
        'photo_preview',
        'image_sizes'
      );
      anchor.firstChild.nodeValue = 'Hide Images';
    } else {
      Hide.these(
        'photo_preview',
        'image_sizes'
      );
      anchor.firstChild.nodeValue = 'See Images';
    }
  },
  
  // Uses server to create preview of content...
  preview_text : function(preview_url) {
    var params = Form.serialize($('photoform'));
    if( params != this.last_preview ) {
      td = $('textdiv')
      while(td.firstChild) td.removeChild(td.firstChild);
      td.appendChild(document.createTextNode("Loading text..."));
      new Ajax.Updater(
         'textdiv',
         preview_url,
         { method: 'post',
           parameters: params }
      );
    }
    this.last_text_preview = params;
  }

}
