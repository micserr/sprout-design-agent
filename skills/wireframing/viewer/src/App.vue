<script setup>
import { ref, defineAsyncComponent } from 'vue'

const vueTemplates = [
  { id: 'dashboard', label: 'Dashboard', component: defineAsyncComponent(() => import('./templates/dashboard.vue')) },
  { id: 'form-page', label: 'Form Page', component: defineAsyncComponent(() => import('./templates/form-page.vue')) },
  { id: 'onboarding-wizard', label: 'Onboarding Wizard', component: defineAsyncComponent(() => import('./templates/onboarding-wizard.vue')) },
  { id: 'settings-page', label: 'Settings Page', component: defineAsyncComponent(() => import('./templates/settings-page.vue')) },
  { id: 'complex-dashboard', label: 'Complex Dashboard', component: defineAsyncComponent(() => import('./templates/complex-dashboard.vue')) },
]

// HTML layout blueprints (imported as raw strings, rendered via iframe srcdoc)
import blueprintDashboard from '../../templates/layout/dashboard.html?raw'
import blueprintFormPage from '../../templates/layout/form-page.html?raw'
import blueprintOnboardingWizard from '../../templates/layout/onboarding-wizard.html?raw'
import blueprintSettingsPage from '../../templates/layout/settings-page.html?raw'
import blueprintComplexDashboard from '../../templates/layout/complex-dashboard.html?raw'

const blueprints = [
  { id: 'dashboard', label: 'Dashboard', html: blueprintDashboard },
  { id: 'form-page', label: 'Form Page', html: blueprintFormPage },
  { id: 'onboarding-wizard', label: 'Onboarding Wizard', html: blueprintOnboardingWizard },
  { id: 'settings-page', label: 'Settings Page', html: blueprintSettingsPage },
  { id: 'complex-dashboard', label: 'Complex Dashboard', html: blueprintComplexDashboard },
]

const mode = ref('vue') // 'vue' | 'blueprint'
const active = ref('dashboard')

const currentVue = () => vueTemplates.find(t => t.id === active.value)
const currentBlueprint = () => blueprints.find(t => t.id === active.value)
</script>

<template>
  <div class="flex flex-col h-screen bg-white">

    <!-- TOOLBAR: mode toggle + template tabs -->
    <div class="flex items-center gap-3 px-4 py-2 border-b border-gray-200 bg-gray-50 shrink-0 overflow-x-auto">

      <!-- MODE TOGGLE -->
      <div class="flex items-center gap-1 bg-gray-200 rounded p-0.5 shrink-0">
        <button
          @click="mode = 'vue'"
          :class="['px-3 py-1 rounded text-xs font-medium transition-colors', mode === 'vue' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700']"
        >Vue</button>
        <button
          @click="mode = 'blueprint'"
          :class="['px-3 py-1 rounded text-xs font-medium transition-colors', mode === 'blueprint' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700']"
        >Blueprint</button>
      </div>

      <!-- DIVIDER -->
      <div class="w-px h-5 bg-gray-300 shrink-0"></div>

      <!-- TEMPLATE TABS -->
      <div class="flex items-center gap-1">
        <button
          v-for="t in (mode === 'vue' ? vueTemplates : blueprints)"
          :key="t.id"
          @click="active = t.id"
          :class="[
            'px-4 py-1.5 rounded text-sm font-medium whitespace-nowrap transition-colors',
            active === t.id
              ? 'bg-gray-900 text-white'
              : 'text-gray-600 hover:bg-gray-200'
          ]"
        >
          {{ t.label }}
        </button>
      </div>
    </div>

    <!-- CONTENT AREA -->
    <div class="flex-1 overflow-auto">

      <!-- VUE MODE: render async Vue components -->
      <template v-if="mode === 'vue'">
        <Suspense>
          <component :is="currentVue().component" />
          <template #fallback>
            <div class="flex items-center justify-center h-full text-gray-400 text-sm">Loading...</div>
          </template>
        </Suspense>
      </template>

      <!-- BLUEPRINT MODE: render HTML blueprints in a full-size iframe via srcdoc -->
      <template v-else>
        <iframe
          :key="active"
          :srcdoc="currentBlueprint().html"
          class="w-full h-full border-0"
          sandbox="allow-scripts"
        />
      </template>

    </div>
  </div>
</template>
