import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import Layout from '../components/Layout';
import api from '../utils/api';

function UserList() {
  const { t } = useTranslation();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await api.get('/users');
      setUsers(response.data.users);
    } catch (error) {
      console.error('Failed to fetch users:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <Layout>
        <div className="loading-screen">
          <div className="spinner"></div>
          <p>{t('common.loading')}</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div>
        <h1>{t('nav.users')}</h1>
        <table className="table">
          <thead>
            <tr>
              <th>{t('auth.firstName')}</th>
              <th>{t('auth.lastName')}</th>
              <th>{t('auth.email')}</th>
              <th>{t('auth.role')}</th>
              <th>{t('content.createdAt')}</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td>{user.firstName}</td>
                <td>{user.lastName}</td>
                <td>{user.email}</td>
                <td>{t(`roles.${user.role}`)}</td>
                <td>{new Date(user.createdAt).toLocaleDateString('he-IL')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </Layout>
  );
}

export default UserList;
