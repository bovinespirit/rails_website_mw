function preview_text(preview_url) {
  var params = Form.serialize($('blogform'));
  pb = $('preview-body');
  while(pb.firstChild) pb.removeChild(pb.firstChild);
  pb.appendChild(document.createTextNode("Loading text..."));
  $('preview-spinner').show();
  new Ajax.Updater(
         'preview-body',
         preview_url,
         { method: 'post',
           parameters: params,
           onComplete: function(){ $('preview-spinner').hide(); } 
           }
      );
}

function hide_preview() {
  pb = $('preview-body');
  while(pb.firstChild) pb.removeChild(pb.firstChild);
}

function view_version(version_url) {
  var params = Form.serialize($('versionform'));
  pb = $('version-view');
  while(pb.firstChild) pb.removeChild(pb.firstChild);
  pb.appendChild(document.createTextNode("Loading text..."));
  $('version-spinner').show();
  new Ajax.Updater(
         'version-view',
         version_url,
         { method: 'post',
           parameters: params,
           onComplete: function(){ $('version-spinner').hide(); } 
           }
      );
}

function hide_version() {
  pb = $('version-view');
  while(pb.firstChild) pb.removeChild(pb.firstChild);
}
