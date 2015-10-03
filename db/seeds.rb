if Rails.env == 'development'
  User.create email: 'shvetsovdm@gmail.com', password: '12345678'
end
