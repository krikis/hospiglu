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

  mrect1 = Shape.create graffle: graffle,
                        in_menu: true,
                        properties: {shape_type: 'rect',
                                     x: 30,
                                     y: 30,
                                     width: 60,
                                     height: 40,
                                     border_radius: 10}

  mrect2 = Shape.create graffle: graffle,
                        in_menu: true,
                        properties: {shape_type: 'rect',
                                     x: 130,
                                     y: 30,
                                     width: 60,
                                     height: 40,
                                     border_radius: 2}

  mellipse1 = Shape.create graffle: graffle,
                           in_menu: true,
                           properties: {shape_type: 'ellipse',
                                        x: 260,
                                        y: 50,
                                        width: 30,
                                        height: 20}

  mellipse2 = Shape.create graffle: graffle,
                           in_menu: true,
                           properties: {shape_type: 'ellipse',
                                        x: 350,
                                        y: 50,
                                        width: 20,
                                        height: 20}

  mconnection1 = Connection.create graffle: graffle,
                                   in_menu: true,
                                   properties: {line_color: '#fff',
                                                x: 400,
                                                y: 40,
                                                x2: 460,
                                                y2: 60,
                                                cx: 430,
                                                cy: 40,
                                                cx2: 430,
                                                cy2: 60}

  mconnection2 = Connection.create graffle: graffle,
                                   in_menu: true,
                                   properties: {line_color: '#000',
                                                background_color: '#fff',
                                                x: 500,
                                                y: 40,
                                                x2: 560,
                                                y2: 60,
                                                cx: 530,
                                                cy: 40,
                                                cx2: 530,
                                                cy2: 60}

  mconnection3 = Connection.create graffle: graffle,
                                   in_menu: true,
                                   properties: {line_color: '#fff',
                                                background_color: '#fff|5',
                                                x: 600,
                                                y: 40,
                                                x2: 660,
                                                y2: 60,
                                                cx: 630,
                                                cy: 40,
                                                cx2: 630,
                                                cy2: 60}

  rect1 = Shape.create graffle: graffle,
                       properties: {shape_type: 'rect',
                                    x: 290,
                                    y: 180,
                                    width: 60,
                                    height: 40,
                                    border_radius: 10}

  rect2 = Shape.create graffle: graffle,
                       properties: {shape_type: 'rect',
                                    x: 290,
                                    y: 280,
                                    width: 60,
                                    height: 40,
                                    border_radius: 2}

  ellipse1 = Shape.create graffle: graffle,
                          properties: {shape_type: 'ellipse',
                                       x: 190,
                                       y: 200,
                                       width: 30,
                                       height: 20}

  ellipse2 = Shape.create graffle: graffle,
                          properties: {shape_type: 'ellipse',
                                       x: 450,
                                       y: 200,
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

  connection3 = Connection.create graffle: graffle,
                                  properties: {line_color: '#000',
                                               background_color: '#fff'},
                                  start_shape: rect1,
                                  end_shape: ellipse2
end