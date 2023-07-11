# Nous importons 'curses', espérant qu'il ne nous jette pas un sort
require 'curses'

# On ne sait jamais quand on aura besoin d'un caractère aléatoire pour sauver la journée, n'est-ce pas ?
def random_char
  (rand(2)==1 ? (65 + rand(26)) : (97 + rand(26))).chr
end

# Préparez-vous, ça va pleuvoir... des lettres !
class Raindrop
  attr_accessor :x, :y, :speed, :length, :chars, :prev_y

  # Vous voyez cette goutte de pluie ? Elle n'était pas là il y a une seconde. Incroyable, non ?
  def initialize(max_y, max_x)
    @x = rand(max_x)
    @y = rand(max_y)
    @length = rand(5..15)
    @speed = rand(1..5)
    @chars = Array.new(@length) { random_char }
    @prev_y = @y
  end

  # Qu'est-ce qui est vert, tombe et change constamment ? Si vous avez pensé à une feuille d'arbre radioactive, désolé, c'est une goutte de pluie de la matrice.
  def fall(max_y)
    @prev_y = @y
    @y += @speed
    @chars.pop if @chars.length > @length
    @chars.unshift(random_char) if @y % 2 == 0
    @y = 0 if @y > max_y + @length
  end
end

# Ici, nous initialisons l'écran et définissons les couleurs que nous allons utiliser.
# Spoiler alert: c'est du vert.
Curses.init_screen
Curses.start_color
Curses.init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
Curses.crmode
Curses.noecho

# Nous obtenons les dimensions de l'écran. En supposant que l'écran est une forme rectangulaire.
max_y = Curses.lines - 1
max_x = Curses.cols - 1

# C'est l'heure de la douche ! Une douche de 100 gouttes de pluie.
raindrops = Array.new(100) { Raindrop.new(max_y, max_x) }

# La boucle infinie : un cauchemar pour les amateurs de performance, un rêve pour les amateurs de pluie de la matrice.
loop do
  raindrops.each do |drop|
    # Faites place, faites place, la goutte de pluie arrive !
    if drop.prev_y - drop.length >= 0
      Curses.setpos(drop.prev_y - drop.length, drop.x)
      Curses.addstr(' ' * drop.length)
    end
    drop.chars.each_with_index do |char, i|
      Curses.setpos(drop.y - i, drop.x)
      # Nous avons un code couleur pour nos gouttes de pluie. Blanc pour le premier, vert pour le reste.
      Curses.attron(Curses.color_pair(i.zero? ? 2 : 1)) { Curses.addstr(char) }
    end
    # Et la goutte de pluie tombe, tombe, tombe...
    drop.fall(max_y)
  end
  # Rafraîchir l'écran est comme prendre une bonne gorgée d'eau fraîche pendant une course. Essentiel, mais souvent oublié.
  Curses.refresh
  # Dormons un peu avant de recommencer. Même les boucles ont besoin de repos.
  sleep 0.05
end
