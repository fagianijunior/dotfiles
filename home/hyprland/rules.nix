{
  windowrule = [
    "float, title:(Media viewer)"
    "opaque, title:(Media viewer)"
    "center, title:^(Open File)(.*)$"
    "center, title:^(Select a File)(.*)$"
    "center, title:^(Choose wallpaper)(.*)$"
    "center, title:^(Open Folder)(.*)$"
    "center, title:^(Save As)(.*)$"
    "center, title:^(Library)(.*)$"
    "center, title:^(File Upload)(.*)$"
  ];

  windowrulev2 = [
    "float, $volume_sidemenu"
    "float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
    "opaque, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
    "opaque, title:^(Netflix)(.*)$"
    "opaque, title:^(.*)(Youtube)(.*)$"
    "suppressevent maximize, class:.*"
    "pin, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$ "
    "opacity 1.0 1.0, class:^(ClickUp)$"
    "opacity 1.0 1.0, class:^(Slack)$"
    "opacity 1.0 1.0, class:^(org.telegram.desktop)$"
    "opacity 1.0 1.0, class:^(firefox)$, title:^(WhatsApp — Mozilla Firefox)$"
  ];
}