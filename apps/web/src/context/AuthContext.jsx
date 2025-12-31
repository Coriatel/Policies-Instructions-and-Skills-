import { createContext, useContext, useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../utils/api';

const AuthContext = createContext(null);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('accessToken');
    if (token) {
      fetchCurrentUser();
    } else {
      setLoading(false);
    }
  }, []);

  const fetchCurrentUser = async () => {
    try {
      const response = await api.get('/users/me');
      setUser(response.data.user);
    } catch (error) {
      console.error('Failed to fetch user:', error);
      logout();
    } finally {
      setLoading(false);
    }
  };

  const login = async (email, password) => {
    const response = await api.post('/auth/login', { email, password });
    const { user: userData, accessToken, refreshToken } = response.data;

    localStorage.setItem('accessToken', accessToken);
    localStorage.setItem('refreshToken', refreshToken);

    setUser(userData);
    return userData;
  };

  const register = async (data) => {
    const response = await api.post('/auth/register', data);
    const { user: userData, accessToken, refreshToken } = response.data;

    localStorage.setItem('accessToken', accessToken);
    localStorage.setItem('refreshToken', refreshToken);

    setUser(userData);
    return userData;
  };

  const logout = () => {
    const refreshToken = localStorage.getItem('refreshToken');
    if (refreshToken) {
      api.post('/auth/logout', { refreshToken }).catch(() => {});
    }

    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    setUser(null);
    navigate('/login');
  };

  const value = useMemo(
    () => ({
      user,
      login,
      register,
      logout,
      isAuthenticated: !!user,
      loading,
    }),
    [user, loading]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
