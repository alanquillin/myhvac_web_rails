json.programs(@programs) do |program|
  json.partial! 'programs/program', program: program
end