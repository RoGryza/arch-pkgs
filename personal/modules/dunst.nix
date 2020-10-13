{
  services.dunst = {
    enable = true;
    settings = {
      global.font = "Monospace 8";
      global.allow_markup = true;
      global.format = "<b>%s %p</b>\n%b";
      global.sort = true;
      global.indicate_hidden = true;
      global.idle_threshold = 0;
      global.geometry = "300x5-20+20";
      global.alignment = "center";
      global.show_age_threshold = 60;
      global.sticky_history = true;
      global.follow = "mouse";
      global.word_wrap = true;
      global.separator_height = 2;
      global.padding = 10;
      global.horizontal_padding = 10;
      global.separator_color = "frame";
      global.startup_notification = true;

      frame.width = 3;
      frame.color = "#000000";

      urgency_low.background = "#ffffff";
      urgency_low.foreground = "#000000";
      urgency_low.timeout = 30;

      urgency_normal.background = "#94dbff";
      urgency_normal.foreground = "#000000";
      urgency_normal.timeout = 45;

      urgency_critical.background = "#ff9999";
      urgency_critical.foreground = "#000000";
      urgency_critical.timeout = 0;
    };
  };
}
