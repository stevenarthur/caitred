shared_examples 'returns an error' do

  it 'has an error status code' do
    expect(response.status).to be 500
  end

end

shared_examples 'OK response' do
  it 'renders an OK response' do
    expect(response.status).to eq 200
  end
end

shared_examples 'temporary redirect' do
  it 'redirects' do
    expect(response.status).to eq 302
  end
end

shared_examples 'bad request' do
  it 'has bad request status' do
    expect(response.status).to eq 400
  end
end

shared_examples 'unprocessable entity' do
  it 'has bad request status' do
    expect(response.status).to eq 422
  end
end

shared_examples 'not found' do
  it 'has not found status' do
    expect(response.status).to eq 404
  end
end
