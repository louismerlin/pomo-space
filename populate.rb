u1 = User.new(:email => 'louis.merlin@epfl.ch')
u1.password = "louis"
u1.password_confirmation = "louis"
u1.save
u2 = User.new(:email => 'patrick.aebischer@epfl.ch')
u2.password = "patrick"
u2.password_confirmation = "patrick"
u2.save
