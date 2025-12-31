import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../context/AuthContext';
import Layout from '../components/Layout';
import api from '../utils/api';

function Dashboard() {
  const { t } = useTranslation();
  const { user } = useAuth();
  const [stats, setStats] = useState({ totalContent: 0, publishedContent: 0 });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const response = await api.get('/content');
      const content = response.data.content;
      setStats({
        totalContent: content.length,
        publishedContent: content.filter((c) => c.isPublished).length,
      });
    } catch (error) {
      console.error('Failed to fetch stats:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <div className="dashboard">
        <h1>
          {t('app.welcome')}, {user?.firstName}!
        </h1>

        {!loading && (
          <div className="stats">
            <div className="stat-card">
              <h3>{t('content.title')}</h3>
              <p>{stats.totalContent}</p>
            </div>
            <div className="stat-card">
              <h3>{t('content.isPublished')}</h3>
              <p>{stats.publishedContent}</p>
            </div>
          </div>
        )}

        <div>
          <Link to="/content" className="btn btn-primary">
            {t('nav.content')}
          </Link>
        </div>
      </div>
    </Layout>
  );
}

export default Dashboard;
