import { Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

function ProtectedRoute({ children, requiredRole }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="loading-screen">
        <div className="spinner"></div>
        <p>טוען...</p>
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (requiredRole && user.role !== requiredRole) {
    return (
      <div className="access-denied">
        <h1>אין הרשאה</h1>
        <p>אין לך הרשאות מתאימות לצפייה בעמוד זה.</p>
      </div>
    );
  }

  return children;
}

export default ProtectedRoute;
