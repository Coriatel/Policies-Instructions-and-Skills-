module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'airbnb',
    'airbnb/hooks',
    'plugin:react/recommended',
    'plugin:jsx-a11y/recommended',
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  rules: {
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'warn',
    'no-console': ['warn', { allow: ['warn', 'error'] }],
    'import/prefer-default-export': 'off',
    'react/jsx-filename-extension': [1, { extensions: ['.jsx', '.js'] }],
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
};
