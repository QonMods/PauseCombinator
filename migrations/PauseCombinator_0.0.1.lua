for _,force in pairs(game.forces) do
  force.recipes["pause-combinator"].enabled = force.technologies["circuit-network"].researched
end

-- game.print('PauseCombinator_0.0.1 migration')