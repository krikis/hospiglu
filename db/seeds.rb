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
  graffle = Graffle.create([{properties: {name: "Graffle #{index}"}}],
                           without_protection: true).first

  mrect1 = Shape.create [{graffle: graffle,
                          in_menu: true,
                          properties: {shape_type: 'rect',
                                       x: 30,
                                       y: 30,
                                       width: 60,
                                       height: 40,
                                       border_radius: 10}}],
                        without_protection: true

  mrect2 = Shape.create [{graffle: graffle,
                          in_menu: true,
                          properties: {shape_type: 'rect',
                                       x: 130,
                                       y: 30,
                                       width: 60,
                                       height: 40,
                                       border_radius: 2}}],
                        without_protection: true

  mellipse1 = Shape.create [{graffle: graffle,
                             in_menu: true,
                             properties: {shape_type: 'ellipse',
                                          x: 260,
                                          y: 50,
                                          width: 30,
                                          height: 20}}],
                           without_protection: true

  mellipse2 = Shape.create [{graffle: graffle,
                             in_menu: true,
                             properties: {shape_type: 'ellipse',
                                          x: 350,
                                          y: 50,
                                          width: 20,
                                          height: 20}}],
                           without_protection: true

  mconnection1 = Connection.create [{graffle: graffle,
                                     in_menu: true,
                                     properties: {type: 'curvedpath',
                                                  stroke: '#fff',
                                                  target: {:'stroke-width' => 20},
                                                  x: 400,
                                                  y: 30,
                                                  x2: 440,
                                                  y2: 70,
                                                  cx: 400,
                                                  cy: 50,
                                                  cx2: 440,
                                                  cy2: 50}}],
                                   without_protection: true

  mconnection2 = Connection.create [{graffle: graffle,
                                     in_menu: true,
                                     properties: {type: 'curvedpath',
                                                  stroke: '#000',
                                                  background: {stroke: '#fff',
                                                               :'stroke-width' => 3},
                                                  target: {:'stroke-width' => 20},
                                                  x: 480,
                                                  y: 30,
                                                  x2: 520,
                                                  y2: 70,
                                                  cx: 480,
                                                  cy: 50,
                                                  cx2: 520,
                                                  cy2: 50}}],
                                   without_protection: true

  mconnection3 = Connection.create [{graffle: graffle,
                                     in_menu: true,
                                     properties: {type: 'curvedpath',
                                                  stroke: '#fff',
                                                  :'stroke-width' => 5,
                                                  target: {:'stroke-width' => 20},
                                                  x: 560,
                                                  y: 30,
                                                  x2: 600,
                                                  y2: 70,
                                                  cx: 560,
                                                  cy: 50,
                                                  cx2: 600,
                                                  cy2: 50}}],
                                   without_protection: true

  trashcan = Connection.create [{graffle: graffle,
                                 in_menu: true,
                                 properties: {type: 'trashcan',
                                              x: 640,
                                              y: 35,
                                              size: 2,
                                              stroke: '#fff',
                                              select_color: '#d14',
                                              target: {type: 'rectangle',
                                                       x: 630,
                                                       y: 20,
                                                       height: 60,
                                                       width: 50}}}],
                               without_protection: true

  rect1 = Shape.create [{graffle: graffle,
                         properties: {shape_type: 'rect',
                                      x: 290,
                                      y: 80,
                                      width: 60,
                                      height: 40,
                                      border_radius: 10}}],
                       without_protection: true

  rect2 = Shape.create [{graffle: graffle,
                         properties: {shape_type: 'rect',
                                      x: 290,
                                      y: 180,
                                      width: 60,
                                      height: 40,
                                      border_radius: 2}}],
                       without_protection: true

  ellipse1 = Shape.create [{graffle: graffle,
                            properties: {shape_type: 'ellipse',
                                         x: 190,
                                         y: 100,
                                         width: 30,
                                         height: 20}}],
                          without_protection: true

  ellipse2 = Shape.create [{graffle: graffle,
                            properties: {shape_type: 'ellipse',
                                         x: 450,
                                         y: 100,
                                         width: 20,
                                         height: 20}}],
                          without_protection: true

  connection1 = Connection.create [{graffle: graffle,
                                    properties: {stroke: '#fff'},
                                    start_shape: ellipse1.first,
                                    end_shape: rect1.first}],
                                  without_protection: true

  connection2 = Connection.create [{graffle: graffle,
                                    properties: {stroke: '#fff',
                                                 :'stroke-width' => 5},
                                    start_shape: rect1.first,
                                    end_shape: rect2.first}],
                                  without_protection: true

  connection3 = Connection.create [{graffle: graffle,
                                    properties: {stroke: '#000',
                                                 background: {stroke: '#fff',
                                                              :'stroke-width' => 3}},
                                    start_shape: rect1.first,
                                    end_shape: ellipse2.first}],
                                  without_protection: true
end