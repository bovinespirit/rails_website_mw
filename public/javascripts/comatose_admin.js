// CSS Browser Selector   v0.2.3b (M@: added noscript support)
// Documentation:         http://rafael.adm.br/css_browser_selector
// License:               http://creativecommons.org/licenses/by/2.5/
// Author:                Rafael Lima (http://rafael.adm.br)
// Contributors:          http://rafael.adm.br/css_browser_selector#contributors
var css_browser_selector = function() {
  var 
    ua = navigator.userAgent.toLowerCase(),
    is = function(t){ return ua.indexOf(t) != -1; },
    h = document.getElementsByTagName('html')[0],
    b = (!(/opera|webtv/i.test(ua)) && /msie (\d)/.test(ua)) ? ((is('mac') ? 'ieMac ' : '') + 'ie ie' + RegExp.$1)
      : is('gecko/') ? 'gecko' : is('opera') ? 'opera' : is('konqueror') ? 'konqueror' : is('applewebkit/') ? 'webkit safari' : is('mozilla/') ? 'gecko' : '',
    os = (is('x11') || is('linux')) ? ' linux' : is('mac') ? ' mac' : is('win') ? ' win' : '';
  var c = b+os+' js'; 
  h.className = h.className.replace('noscript', '') + h.className?' '+c:c;
}();


// List View Functions
var ComatoseList = {
  toggle_tree_nodes : function(img, id) {
    if(/expanded/.test(img.src)) {
      $('page_list_'+ id).addClassName('collapsed');
      img.src = img.src.replace(/expanded/, 'collapsed')
    } else {
      $('page_list_'+ id).removeClassName('collapsed');
      img.src = img.src.replace(/collapsed/, 'expanded')
    }
  },
  expand_node: function(id) {
    $('page_list_'+ id).removeClassName('collapsed');
    $('page_controller_'+ id).src = $('page_controller_'+ id).src.replace(/collapsed/, 'expanded')    
  },
  collapse_node: function(id) {
    $('page_list_'+ id).addClassName('collapsed');
    $('page_controller_'+ id).src = $('page_controller_'+ id).src.replace(/expanded/, 'collapsed')    
  },
  item_hover : function(node, state, is_delete) {
    if( state == 'over') {
      $(node).addClassName( (is_delete) ? 'hover-delete' : 'hover' );
    } else {
      $(node).removeClassName( (is_delete) ? 'hover-delete' : 'hover' );
    }
  },
  // Todo: Make the tree nodes remember their visibility?
  toggle_reorder: function(node, anc, id) {
    if( $(node).hasClassName('do-reorder') ) {
      $(node).removeClassName( 'do-reorder' );
      $(anc).removeClassName('reordering');
      $(anc).innerHTML = "reorder children";
    } else {
      $(node).addClassName( 'do-reorder' );
      $(anc).addClassName('reordering');
      $(anc).innerHTML = "finished reordering";
      // Make sure the children are visible...
      ComatoseList.expand_node(id);
    }
  }
}

// Edit Form Functions
var ComatoseEditForm = {
  default_data: {},
  last_preview: {},
  last_title_slug: '',
  last_menu_title: '',
  mode : null,
  liquid_horiz: false,
  width_offset: 325,
  // Initialize the page...
  init : function(mode) {
    this.mode = mode;
    this.default_data = Form.serialize(document.forms[0]);
    if(mode == 'new') {
      this.last_title_slug = $('page_title').value.toSlug();
      this.last_menu_title = $('page_title').value;
      Event.observe('page_title', 'blur', ComatoseEditForm.title_updated_aggressive);
    } else {
      Event.observe('page_title', 'blur', ComatoseEditForm.title_updated);
    }
    $('page_title').focus();
    Hide.these(
      'preview-area',
      'slug_row',
      'parent_row',
      'keywords_row',
      'filter_row',
      'created_row',
      'menu_title_row',
      'photo_set_row'
    );
    $('page_title').select();
    // Create the horizontal liquidity of the fields
    if(this.liquid_horiz) {
      xOffset = this.width_offset;
      new Layout.LiquidHoriz((xOffset + 50), 'page_title');
      new Layout.LiquidHoriz(xOffset, 'page_slug','page_keywords','page_parent','page_body');
    }
  },
  // For use when updating an existing page...
  title_updated : function() {
    slug = $('page_slug');
    menu_title = $('page_menu_title')
    if(slug.value == "") {
      title = $('page_title');
      slug.value = title.value.toSlug();
    }
    if(menu_title.value == "") {
      menu_title.value = title.value;
    }
  },
  // For use when creating a new page...
  title_updated_aggressive : function() {
    slug = $('page_slug');
    title = $('page_title');
    menu_title = $('page_menu_title')
    if(slug.value == "" || slug.value == this.last_title ) {
      slug.value = title.value.toSlug();
    }
    this.last_title = slug.value;
    if(menu_title.value == "" || menu_title.value == this.last_menu_title ) {
      menu_title.value = title.value;
    }
    this.last_menu_title = menu_title.value;
  },
  // Todo: Make the meta fields remember their visibility?
  toggle_extra_fields : function(anchor) {
    if(anchor.innerHTML == "More...") {
      Show.these(
        'slug_row',
        'keywords_row',
        'parent_row',
        'filter_row',
        'created_row',
        'menu_title_row',
        'photo_set_row'
      );
      anchor.innerHTML = 'Less...';
    } else {
      Hide.these(
        'slug_row',
        'keywords_row',
        'parent_row',
        'filter_row',
        'created_row',
        'menu_title_row',
        'photo_set_row'
      );
      anchor.innerHTML = 'More...';
    }
  },
  // Uses server to create preview of content...
  preview_content : function(preview_url) {
    $('preview-area').show();
    var params = Form.serialize(document.forms[1]);
    if( params != this.last_preview ) {
      $('preview-panel').innerHTML = "<span style='color:blue;'>Loading Preview...</span>";
      new Ajax.Updater(
         'preview-panel',
         preview_url,
         { parameters: params }
      );
    }
    this.last_preview = params;
  },
  cancel : function(url) {
    var current_data = Form.serialize(document.forms[0]);
    var data_changed = (this.default_data != current_data) 
    if(data_changed) {
      if( confirm('Changes detected. You will lose all the updates you have made if you proceed...') ) {
        location.href = url;
      }
    } else {
      location.href = url;      
    }
    
  }
}

var Hide = {
  these : function() {
    for (var i = 0; i < arguments.length; i++) {
      try {
        $(arguments[i]).hide();
      } catch (e) {}
    }
  }
}
var Show = {
  these : function() {
    for (var i = 0; i < arguments.length; i++) {
      try {
        $(arguments[i]).show();
      } catch (e) {}
    }
  }
}

// Layout namespace
var Layout = {};

// This class allows dom objects to stretch with the browser 
// (for when a good, cross-browser, CSS approach can't be found)
Layout.LiquidBase = Class.create();
// Base class for all Liquid* layouts...
Object.extend(Layout.LiquidBase.prototype, {
  enabled: true,
  elems: [],
  offset: null,
  // Constructor is (offset, **array_of_elements)
  initialize: function() {
    args = $A(arguments)
    this.offset = args.shift();
    this.elems = args.select( function(elem){ return ($(elem) != null) } );
    if( this.elems.length > 0 ) {
      this.on_resize(); // Initial size
      Event.observe(window, 'resize', this.on_resize.bind(this) );
      Event.observe(window, 'load', this.on_resize.bind(this) );
    }
  },
  resize_in: function(timeout) {
    setTimeout( this.on_resize.bind(this), timeout );
  },
  on_resize: function() {       
    // Need to override!
    alert('Override on_resize, please!');
  }
});


// Liquid vertical layout
Layout.LiquidVert = Class.create();
Object.extend(Layout.LiquidVert.prototype, Object.extend(Layout.LiquidBase.prototype, {
  on_resize: function() {       
    if( this.offset != null && this.enabled ) {
      var new_height = ((window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight) - this.offset) +"px";
      this.elems.each(function(e){ $(e).style.height = new_height; })
    }
  }
}) );


// Liquid horizontal layout
Layout.LiquidHoriz = Class.create();
Object.extend(Layout.LiquidHoriz.prototype, Object.extend(Layout.LiquidBase.prototype, {
  on_resize: function() {       
    if( this.offset != null && this.enabled ) {
      var new_width = ((window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth) - this.offset) +"px";
      this.elems.each( function(e){ $(e).style.width = new_width; })
    }
  }
}) );

// String Extensions... Yes, these are from Radiant! ;-)
Object.extend(String.prototype, {
  upcase: function() {
    return this.toUpperCase();
  },
  downcase: function() {
    return this.toLowerCase();
  },
  strip: function() {
    return this.replace(/^\s+/, '').replace(/\s+$/, '');
  },
  toInteger: function() {
    return parseInt(this);
  },
  toSlug: function() {
    // M@: Modified from Radiant's version, removes multple --'s next to each other
    // This is the same RegExp as the one on the page model...
    return this.strip().downcase().replace(/[^-a-z0-9~\s\.:;+=_]/g, '').replace(/[\s\.:;=_+]+/g, '-').replace(/[\-]{2,}/g, '-');
  }
});

// Run a spinner when an AJAX request in running...
var ComatoseAJAXSpinner = {
  busy : function () {
    if($('spinner') && Ajax.activeRequestCount > 0) {
      Effect.Appear('spinner',{duration:0.5,queue:'end'});
    }
  },

  notBusy: function() {
    if($('spinner') && Ajax.activeRequestCount == 0) {
      Effect.Fade('spinner',{duration:0.5,queue:'end'});
    }
  }  
}
// Register it with Prototype...
Ajax.Responders.register({
  onCreate: ComatoseAJAXSpinner.busy, 
  onComplete: ComatoseAJAXSpinner.notBusy
});