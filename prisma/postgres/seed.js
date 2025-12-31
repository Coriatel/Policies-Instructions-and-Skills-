const { PrismaClient } = require('@prisma/client-postgres');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting seed...');

  // Create admin user
  const adminPassword = await bcrypt.hash('Admin123!', 10);
  const admin = await prisma.user.upsert({
    where: { email: 'admin@crm.local' },
    update: {},
    create: {
      email: 'admin@crm.local',
      password: adminPassword,
      firstName: 'Admin',
      lastName: 'User',
      role: 'ADMIN',
      isActive: true,
    },
  });
  console.log('✅ Admin user created:', admin.email);

  // Create sample male user
  const malePassword = await bcrypt.hash('Male123!', 10);
  const male = await prisma.user.upsert({
    where: { email: 'male@crm.local' },
    update: {},
    create: {
      email: 'male@crm.local',
      password: malePassword,
      firstName: 'David',
      lastName: 'Cohen',
      role: 'MALE',
      isActive: true,
    },
  });
  console.log('✅ Male user created:', male.email);

  // Create sample female user
  const femalePassword = await bcrypt.hash('Female123!', 10);
  const female = await prisma.user.upsert({
    where: { email: 'female@crm.local' },
    update: {},
    create: {
      email: 'female@crm.local',
      password: femalePassword,
      firstName: 'Sarah',
      lastName: 'Levi',
      role: 'FEMALE',
      isActive: true,
    },
  });
  console.log('✅ Female user created:', female.email);

  // Create sample content
  const publicContent = await prisma.content.upsert({
    where: { id: '00000000-0000-0000-0000-000000000001' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000001',
      title: 'ברוכים הבאים לפלטפורמה',
      description: 'תוכן ציבורי הפתוח לכולם',
      body: 'זהו תוכן לדוגמה שכל המשתמשים יכולים לראות.',
      visibility: 'PUBLIC',
      authorId: admin.id,
      isPublished: true,
    },
  });
  console.log('✅ Public content created');

  const maleContent = await prisma.content.upsert({
    where: { id: '00000000-0000-0000-0000-000000000002' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000002',
      title: 'תוכן לגברים בלבד',
      description: 'תוכן מיועד לגברים',
      body: 'תוכן זה נגיש רק למשתמשים עם הרשאת גבר או מנהל.',
      visibility: 'MALE_ONLY',
      authorId: admin.id,
      isPublished: true,
    },
  });
  console.log('✅ Male-only content created');

  const femaleContent = await prisma.content.upsert({
    where: { id: '00000000-0000-0000-0000-000000000003' },
    update: {},
    create: {
      id: '00000000-0000-0000-0000-000000000003',
      title: 'תוכן לנשים בלבד',
      description: 'תוכן מיועד לנשים',
      body: 'תוכן זה נגיש רק למשתמשות עם הרשאת אישה או מנהל.',
      visibility: 'FEMALE_ONLY',
      authorId: admin.id,
      isPublished: true,
    },
  });
  console.log('✅ Female-only content created');

  console.log('🎉 Seed completed successfully!');
  console.log('\n📝 Test accounts:');
  console.log('   Admin:  admin@crm.local / Admin123!');
  console.log('   Male:   male@crm.local / Male123!');
  console.log('   Female: female@crm.local / Female123!');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
