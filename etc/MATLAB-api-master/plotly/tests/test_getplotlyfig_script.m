%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test user does not exist
fprintf('Testing: User Does Not Exist\n');
figure = test_getplotlyfig(...
    'user_does_not_exist', ...
    'api_key_shouldnt_matter', ...
    'file_owner',...
    0,...
    404);
fprintf('Test passed\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test file does not exist
fprintf('Testing: File does not exist\n');
figure = test_getplotlyfig(...
    'plotlyimagetest', ...
    '786r5mecv0', ...
    'get_test_user', ...
    1000, ...
    404);
fprintf('Test passed\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test wrong api key
fprintf('Testing: Wrong API key\n');
figure = test_getplotlyfig(...
    'plotlyimagetest', ...
    'invalid_api_key', ...
    'get_test_user', ...
    1, ...
    401);
fprintf('Test passed\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%
%% test permission denied
fprintf('Testing: Permission denied\n');
figure = test_getplotlyfig(...
    'plotlyimagetest', ...
    '786r5mecv0', ...
    'get_test_user', ...
    1, ... % 1 is a private file
    403);
fprintf('Test passed\n\n');

%%%%%%%%%%%%%%%%%%%%%%
%% test valid response
fprintf('Testing: Valid Response\n');
figure = test_getplotlyfig(...
    'plotlyimagetest', ...
    '786r5mecv0', ...
    'get_test_user', ...
    0, ...
    200);
assert(all(cellfun(@strcmp, figure.data{1}.x, {'1','2','3'})), 'Wrong data retrieved.')
fprintf('Test passed\n\n');