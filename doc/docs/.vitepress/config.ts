import { defineConfig } from 'vitepress'

// https://vitepress.vuejs.org/config/app-configs
export default defineConfig({
  base: '/solvestack/', 
  title: 'solvestack',
  description: '记录我的学习与开发历程',
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  outDir: '../../docs', 
  
  themeConfig: {
    logo: '/favicon.ico',
    
    // 顶部导航栏
    nav: [
      { text: '首页', link: '/' },
      { text: '运行', link: '/run/' },
      { text: '使用', link: '/usage/' },
    ],

    // 左侧侧边栏
    sidebar: {
      '/run': [
        {
          text: '运行',
          items: [ 
            { text: '安装', link: '/run/install' },
            { text: '部署架构', link: '/run/architecture' },
            { text: 'solve服务运行架构 ', link: '/run/architecture_solve' },
            { text: '设置', link: '/run/setting' },
            { text: '更新', link: '/run/upgrade' },
            { text: '调试', link: '/run/debug' },
          ]
        }
      ],
      '/usage': [
        {
          text: '使用',
          items: [ 
            { text: '使用简介', link: '/usage/usage' },
            { text: '任务', link: '/usage/job' },
            { text: 'playbook', link: '/usage/playbook' },
            { text: '扩展命令', link: '/usage/extend_command' },
            { text: '执行对象', link: '/usage/target' },
            { text: '底层执行', link: '/usage/execution_base' },
            { text: 'permanenttoken', link: '/usage/permanenttoken' },
            { text: 'permanenttoken用于执行工单', link: '/usage/permanenttoken_execution' },
          ]
        }
      ]
    },

    // 社交链接
    socialLinks: [
      { icon: 'github', link: 'https://github.com/weideguo/solvestack' }
    ]
  }
})
