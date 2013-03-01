# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Graffle.destroy_all
Shape.destroy_all
Connection.destroy_all

3.times do |index|
  graffle = Graffle.create properties: {name: "Graffle #{index}"}

  rect1 = Shape.create graffle: graffle,
                       in_menu: true,
                       properties: {shape_type: 'rect',
                                    x: 60,
                                    y: 50,
                                    width: 60,
                                    height: 40,
                                    border_radius: 10}

  rect2 = Shape.create graffle: graffle,
                       in_menu: true,
                       properties: {shape_type: 'rect',
                                    x: 160,
                                    y: 50,
                                    width: 60,
                                    height: 40,
                                    border_radius: 2}

  ellipse1 = Shape.create graffle: graffle,
                          in_menu: true,
                          properties: {shape_type: 'ellipse',
                                       x: 260,
                                       y: 50,
                                       width: 30,
                                       height: 20}

  ellipse2 = Shape.create graffle: graffle,
                          in_menu: true,
                          properties: {shape_type: 'ellipse',
                                       x: 360,
                                       y: 50,
                                       width: 20,
                                       height: 20}

  rect1 = Shape.create graffle: graffle,
                       properties: {shape_type: 'rect',
                                    x: 290,
                                    y: 80,
                                    width: 60,
                                    height: 40,
                                    border_radius: 10}

  rect2 = Shape.create graffle: graffle,
                       properties: {shape_type: 'rect',
                                    x: 290,
                                    y: 180,
                                    width: 60,
                                    height: 40,
                                    border_radius: 2}

  ellipse1 = Shape.create graffle: graffle,
                          properties: {shape_type: 'ellipse',
                                       x: 190,
                                       y: 100,
                                       width: 30,
                                       height: 20}

  ellipse2 = Shape.create graffle: graffle,
                          properties: {shape_type: 'ellipse',
                                       x: 450,
                                       y: 100,
                                       width: 20,
                                       height: 20}

  connection1 = Connection.create graffle: graffle,
                                  properties: {line_color: '#fff'},
                                  start_shape: ellipse1,
                                  end_shape: rect1

  connection2 = Connection.create graffle: graffle,
                                  properties: {line_color: '#fff',
                                               background_color: '#fff|5'},
                                  start_shape: rect1,
                                  end_shape: rect2

  connection2 = Connection.create graffle: graffle,
                                  properties: {line_color: '#000',
                                               background_color: '#fff'},
                                  start_shape: rect1,
                                  end_shape: ellipse2
end