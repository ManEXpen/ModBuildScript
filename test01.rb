require 'qt4'
exit if defined?(Ocra)

app = Qt::Application.new(ARGV)
w = Qt::Label.new("NextGen.")
w.show
app.exec