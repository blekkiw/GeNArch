GeNArch - Джентльменский Набор Арч Линукс
===========================================
- [GeNArch English](README.MD)
- [GeNArch Russian](README-RU.MD)

В чем суть проблемы?
--------------------
Я очень люблю арч, но не очень люблю его устанавливать. Проблема не в самой инсталяции, как можно было бы подумать. Проблема в том, что я всегда забываю какие пакеты вообще нужны для нормального функционирования. Очень обидно когда спустя неделю выясняется что в системе нету `less`.

Данный репозиторий содержит набор скриптов, которые я буду использовать для собственных установок Арч. Пожелания и предложения - приветствуются. Единственный файл который не подлежит обсуждению - 005. Он будет содержать приложения, которые нужны лично мне. Вы же можете выполнять скрипты в удобном вам порядке, форкать как вам надо, и делать свой собственный набор программ которые всегда должны быть под рукой.

Скрипты расчитаны на то, что у вас как минимум установлен и настроен `sudo`, а так же есть интернет. Об этом необходимо озаботиться самостоятельно.

Описание скриптов
-----------------

### 000 - Starter
Скрипт позволяет запускать другие скрипты из одного места

### 001 - Post Install
Скрипт устанавливает самый минимальный набор пакетов для базовой работы системы. Пакеты, которые как я считаю по хорошему должны быть в base. Тут и `less`, `curl`, `git`, а так же разнообразные драйвера для железяк.

### 002 - Pacman Tweaks
Необязательный скрипт который минимально настраивает `pacman`. Включает `multilib`, настраивает рефлектор, параллельные загрузки, ну и конечно же конфетки.

### 003 - Additional
Скрипт устанавливает `yay` и кучу доп пакетов для любой нормальной системы. Архиваторы, принтеры, утилиты. Все то, что не привязано к DE.

### 004-1 - Hyprland 
Скрипт устанавливает [JaKooLit Hyprland](https://github.com/JaKooLit/Arch-Hyprland). Почему он? Ну, перепробовав десяток, могу сказать что эта сборка самая законченная, гибкая, и на 100% дает ready for work окружение.

### 004-2 - Plasma
Скрипт устанавливает полный пакет Plasma и несколько дополнительных пакетов которые бы тоже должны идти с ней.

### 005 - My Apps
Не обязательный скрипт который устанавливает мои приложения. Все что мне нужно для работы. Основной набор того, что я использую каждый день. Как можете понять - скрипт для большинства не обязательный.

### 006 - Plymouth
Еще один не обязательный скрипт с твиком. Устанавливает и настраивает `Plymouth`. 

