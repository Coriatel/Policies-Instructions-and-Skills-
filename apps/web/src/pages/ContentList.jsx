import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Layout from '../components/Layout';
import api from '../utils/api';

function ContentList() {
  const { t } = useTranslation();
  const [content, setContent] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchContent();
  }, []);

  const fetchContent = async () => {
    try {
      const response = await api.get('/content');
      setContent(response.data.content);
    } catch (error) {
      console.error('Failed to fetch content:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm(t('common.confirm'))) return;

    try {
      await api.delete(`/content/${id}`);
      setContent((prev) => prev.filter((c) => c.id !== id));
    } catch (error) {
      console.error('Failed to delete content:', error);
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
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2rem' }}>
          <h1>{t('nav.content')}</h1>
          <Link to="/content/new" className="btn btn-primary">
            {t('nav.createContent')}
          </Link>
        </div>

        {content.length === 0 ? (
          <p>{t('content.noContent')}</p>
        ) : (
          <div className="content-grid">
            {content.map((item) => (
              <div key={item.id} className="content-card">
                <h3>{item.title}</h3>
                <span className="visibility-badge">{t(`visibility.${item.visibility}`)}</span>
                <p>{item.description}</p>
                <div className="actions">
                  <Link to={`/content/${item.id}/edit`} className="btn btn-secondary">
                    {t('content.edit')}
                  </Link>
                  <button
                    onClick={() => handleDelete(item.id)}
                    className="btn btn-danger"
                    type="button"
                  >
                    {t('content.delete')}
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </Layout>
  );
}

export default ContentList;
