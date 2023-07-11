require 'curses'

# Un petit coup de dés pour nous donner un caractère aléatoire. C'est comme la loterie, mais tout le monde gagne !
def random_char
  (rand(2)==1 ? (65 + rand(26)) : (97 + rand(26))).chr
end

class Raindrop
  attr_accessor :x, :y, :speed, :length, :chars, :prev_y, :color

  # Voici une nouvelle goutte de pluie, fraîchement tombée du nuage de code.
  def initialize(max_y, max_x)
    @x = rand(max_x)
    @y = rand(max_y)
    @length = rand(5..15)
    @speed = rand(1..5)
    @chars = Array.new(@length) { random_char }
    @prev_y = @y
    @color = rand(1..7)  # Nous voulons un arc-en-ciel, pas une pluie monotone !
  end

  # Faisons tomber cette goutte ! Mais attention, elle se régénère au sommet. C'est une pluie infinie, après tout.
  def fall(max_y)
    @prev_y = @y
    @y += @speed
    @chars.pop if @chars.length > @length
    @chars.unshift(random_char) if @y % 2 == 0
    @y = 0 if @y > max_y + @length
  end
end

# Apprêtez-vous à voir de la magie en couleur !
Curses.init_screen
Curses.start_color
Curses.use_default_colors  # Parce que nous aimons les couleurs naturelles.

# C'est l'heure de peindre un arc-en-ciel dans la console ! N'est-ce pas excitant ?
Curses.init_pair(1, Curses::COLOR_RED, -1) # Un peu de rouge pour réchauffer les choses.
Curses.init_pair(2, Curses::COLOR_YELLOW, -1) # Jaune, comme un bon fromage.
Curses.init_pair(3, Curses::COLOR_GREEN, -1) # Vert, comme un code sain.
Curses.init_pair(4, Curses::COLOR_CYAN, -1) # Cyan, juste parce que c'est joli.
Curses.init_pair(5, Curses::COLOR_BLUE, -1) # Bleu comme un ciel sans bugs.
Curses.init_pair(6, Curses::COLOR_MAGENTA, -1) # Magenta, parce que pourquoi pas ?
Curses.init_pair(7, Curses::COLOR_WHITE, -1) # Et blanc, pour équilibrer toutes ces couleurs.

Curses.crmode
Curses.noecho  # Shh, silence ! Laissons le code parler.

max_y = Curses.lines - 1
max_x = Curses.cols - 1

# Et si nous faisions pleuvoir un arc-en-ciel ?
raindrops = Array.new(100) { Raindrop.new(max_y, max_x) }

# Et maintenant, le spectacle commence ! Asseyez-vous et profitez du spectacle multicolore.
loop do
  raindrops.each do |drop|
    if drop.prev_y - drop.length >= 0
      Curses.setpos(drop.prev_y - drop.length, drop.x)
      Curses.addstr(' ' * drop.length)
    end
    drop.chars.each_with_index do |char, i|
      Curses.setpos(drop.y - i, drop.x)
      Curses.attron(Curses.color_pair(drop.color)) { Curses.addstr(char) } # Qui a dit que la pluie devait être grise ?
    end
    drop.fall(max_y)
  end
  Curses.refresh  # Un petit coup de frais sur l'écran, et on recommence !
  sleep 0.05  # Même un code a besoin de faire une pause de temps en temps.
end
