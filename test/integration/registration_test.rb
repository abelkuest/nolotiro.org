# frozen_string_literal: true
require 'test_helper'

require 'integration/concerns/authentication'

class RegistrationTest < ActionDispatch::IntegrationTest
  include Authentication

  before do
    visit root_path
    click_link 'nuevo usuario'
    fill_in 'Tu email', with: 'nolotiro@example.com'
    fill_in 'Elige tu contraseña', with: '111111'
    fill_in 'Introduce tu contraseña', with: '111111'
    fill_in 'Elige un nombre de usuario', with: 'nolotiro'
    click_button 'Regístrate'
  end

  it 'sends a confirmation email' do
    assert_content <<~MSG
      Se ha enviado un mensaje con un enlace de confirmación a tu correo
      electrónico.
    MSG
  end

  it 'redirects to change city page after first login' do
    User.first.confirm
    login('nolotiro@example.com', '111111')

    assert_content 'Cambia tu ciudad'
  end
end