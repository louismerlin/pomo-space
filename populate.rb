u1 = User.new(:email => 'louis.merlin@epfl.ch', :first_name => 'Louis', :last_name => 'Merlin')
u1.password = "louis"
u1.password_confirmation = "louis"
u1.save

u2 = User.new(:email => 'patrick.aebischer@epfl.ch', :first_name => 'Patrick', :last_name => 'Aebischer')
u2.password = "patrick"
u2.password_confirmation = "patrick"
u2.save

p1 = Pomodoro.new(:h => Time.now())
p1.save
u1.add_pomodoro(p1)

t1 = Tag.new(:title => "Code")
t2 = Tag.new(title: "Analyse")
t1.save
t2.save
u1.add_tag(t1)
u1.add_tag(t2)
p1.add_tag(t1)

#puts User[:id => 1].email
#puts p1.user
#p1.user = User[:id => 1]
