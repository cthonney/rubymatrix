# Nous avons besoin de la gem 'curses' pour créer l'interface de la console
require 'curses'

# Cette fonction génère un caractère aléatoire
def random_char
  (rand(2)==1 ? (65 + rand(26)) : (97 + rand(26))).chr
end

# Cette classe représente une "goutte de pluie" dans l'effet Matrix.
class Raindrop
  attr_accessor :x, :y, :speed, :length, :chars

  # Lors de l'initialisation, nous définissons la position, la vitesse et la longueur de la goutte de pluie.
  # Nous créons également une liste de caractères aléatoires pour la goutte de pluie.
  def initialize(max_y, max_x)
    @x = rand(max_x)
    @y = rand(max_y)
    @length = rand(5..15)
    @speed = rand(1..5)
    @chars = Array.new(@length) { random_char }
  end

  # Cette méthode fait "tomber" la goutte de pluie, en déplaçant sa position et en mettant à jour sa liste de caractères.
  def fall(max_y)
    @y += @speed
    @chars.pop if @chars.length > @length
    @chars.unshift(random_char) if @y % 2 == 0
    @y = 0 if @y > max_y + @length
  end
end

# Ici, nous initialisons l'écran et définissons les couleurs que nous allons utiliser.
Curses.init_screen
Curses.start_color
Curses.init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
Curses.crmode
Curses.noecho

# Nous obtenons les dimensions de l'écran.
max_y = Curses.lines - 1
max_x = Curses.cols - 1

# Nous créons une liste de gouttes de pluie.
raindrops = Array.new(100) { Raindrop.new(max_y, max_x) }

# C'est la boucle principale du programme. À chaque étape, nous effaçons l'écran, dessinons les gouttes de pluie,
# les faisons tomber, puis rafraîchissons l'écran.
loop do
  Curses.clear
  raindrops.each do |drop|
    drop.chars.each_with_index do |char, i|
      Curses.setpos(drop.y - i, drop.x)
      # Nous utilisons une couleur différente pour le premier caractère de chaque goutte de pluie.
      Curses.attron(Curses.color_pair(i.zero? ? 2 : 1)) { Curses.addstr(char) }
    end
    drop.fall(max_y)
  end
  Curses.refresh
  sleep 0.05
end
