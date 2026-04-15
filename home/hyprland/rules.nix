{
  windowrule = [
    "float on, match:title (Media viewer)"
    "opaque on, match:title (Media viewer)"
    "center on, match:title ^(Open File)(.*)$"
    "center on, match:title ^(Select a File)(.*)$"
    "center on, match:title ^(Choose wallpaper)(.*)$"
    "center on, match:title ^(Open Folder)(.*)$"
    "center on, match:title ^(Save As)(.*)$"
    "center on, match:title ^(Library)(.*)$"
    "center on, match:title ^(File Upload)(.*)$"
    "float on, $volume_sidemenu"
    "float on, match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
    "opaque on, match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
    "opaque on, match:title ^(Netflix)(.*)$"
    "opaque on, match:title ^(.*)(Youtube)(.*)$"
    "suppress_event fullscreen maximize, match:class .*"
    "pin on, match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
  ];
}
