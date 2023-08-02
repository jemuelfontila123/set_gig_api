module RequestSpecHelper
  def admin_login(admin)
    post api_v1_admin_auth_path, params: { username: 'superadmin', password: 'Minimumisten1#'}
    json = JSON.parse(response.body).deep_symbolize_keys 
    json[:token]
  end
end