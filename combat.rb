#!/usr/bin/env ruby
#
# combat.rb
# A basic combat tracker, using the rules that I play with in D&D 5e.
# Feel free to play around with the script if you do things otherwise.
#
# Written by:  Mohsin Rizvi
# Last edited: 03/12/18

# Combat
# Used to represent a combat scene.
class Combat

    # initialize
    # Purpose:    Run the combat tracker.
    # Parameters: n/a
    # Return:     n/a
    def initialize
        info
        initFighters(inpMinNum(2, "> How many combatants are there?"))
    end

    # initFighters
    # Purpose:    Initialize the fighters in combat.
    # Parameters: The amount of fighters to initialize.
    # Return:     n/a
    def initFighters len
        @fighters = []
        count = 1
        while count <= len
            puts "> Creating combatant #{count}..."

            # Get combatant data
            puts "> What is this combatant's name?"
            name = gets.chomp
            hp   = inpMinNum(1, "> What is this combatant's HP?")
            ac   = inpMinNum(1, "> What is this combatant's armor class?")
            init = inpMinNum(1, "> What is this combatant's initiative?")

            # Create the combatant
            @fighters.push Fighter.new(name, hp, ac, init)

            count += 1
        end

        # Sort the combatants
        @fighters = @fighters.sort_by {|i| i.init}.reverse
    end


    # info
    # Purpose:    Print out program info.
    # Parameters: n/a
    # Return:     n/a
    def info
        puts ">> dm-tools combat tracker 0.0.1\n" + 
             ">> created by Mohsin Rizvi\n" +
             "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end

end

# Fighter
# Used to represent a combatant.
class Fighter

    # initialize
    # Purpose:    Initialize a Fighter with the given stats.
    # Parameters: A name, the number of hitpoints, the armor class, and the 
    #             initiative.
    # Return:     n/a
    def initialize(name, hp, ac, init)
        @name = name
        @hp   = hp
        @ac   = ac
        @init = init
    end

    # to_s
    # Purpose:    Override the to_s function to allow printing a Fighter.
    # Paramaters: n/a
    # Return:     n/a
    def to_s
        return "#{@name}: HP: #{@hp}, AC: #{@ac}, initiative: #{@init}"
    end

    # name
    # Purpose:    Access the name attribute.
    # Parameters: n/a
    # Return:     n/a
    def name
        return @name
    end

    # hp
    # Purpose:    Access the hp attribute.
    # Parameters: n/a
    # Return:     n/a
    def hp
        return @hp
    end

    # ac
    # Purpose:    Access the ac attribute.
    # Parameters: n/a
    # Return:     n/a
    def ac
        return @ac
    end

    # init
    # Purpose:    Access the init attribute.
    # Parameters: n/a
    # Return:     n/a
    def init
        return @init
    end

end

# inpMinNum
# Purpose:    Read numbers from standard input until a number is read with 
#             the given minimum value.
# Parameters: A minimum value for the number and a message to print on each
#             attempted read.
# Return:     A number.
def inpMinNum(min, message)
    curr = -1

    # Attempt to get a number
    begin
        puts message
        curr = Integer(gets.chomp)
        if curr < min
            raise
        end
    # Catch raised exceptions
    rescue
        retry
    end

    return curr
end

# Clear the screen
system "clear" or system "cls"
# Run combat
c = Combat.new