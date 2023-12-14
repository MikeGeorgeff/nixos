{ config, ... }:
{
    programs.git = {
        enable = true;
        userName = "Mike Georgeff";
        userEmail = "mike@georgeff.co";
    };
}