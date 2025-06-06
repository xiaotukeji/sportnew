<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportBaseItem') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportBaseItemTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('categoryId')" prop="category_id">
                        <el-input v-model="sportBaseItemTable.searchParam.category_id" :placeholder="t('categoryIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportBaseItemTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('code')" prop="code">
                        <el-input v-model="sportBaseItemTable.searchParam.code" :placeholder="t('codePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('competitionType')" prop="competition_type">
                        <el-input v-model="sportBaseItemTable.searchParam.competition_type" :placeholder="t('competitionTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('genderType')" prop="gender_type">
                        <el-input v-model="sportBaseItemTable.searchParam.gender_type" :placeholder="t('genderTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('ageGroup')" prop="age_group">
                        <el-input v-model="sportBaseItemTable.searchParam.age_group" :placeholder="t('ageGroupPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('description')" prop="description">
                        <el-input v-model="sportBaseItemTable.searchParam.description" :placeholder="t('descriptionPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('rules')" prop="rules">
                        <el-input v-model="sportBaseItemTable.searchParam.rules" :placeholder="t('rulesPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('equipment')" prop="equipment">
                        <el-input v-model="sportBaseItemTable.searchParam.equipment" :placeholder="t('equipmentPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('venueRequirements')" prop="venue_requirements">
                        <el-input v-model="sportBaseItemTable.searchParam.venue_requirements" :placeholder="t('venueRequirementsPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('refereeRequirements')" prop="referee_requirements">
                        <el-input v-model="sportBaseItemTable.searchParam.referee_requirements" :placeholder="t('refereeRequirementsPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportBaseItemTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportBaseItemTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportBaseItemTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportBaseItemTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportBaseItemTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportBaseItemList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportBaseItemTable.data" size="large" v-loading="sportBaseItemTable.loading">
                    <template #empty>
                        <span>{{ !sportBaseItemTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="category_id" :label="t('categoryId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="code" :label="t('code')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="competition_type" :label="t('competitionType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="gender_type" :label="t('genderType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="age_group" :label="t('ageGroup')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="description" :label="t('description')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="rules" :label="t('rules')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="equipment" :label="t('equipment')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="venue_requirements" :label="t('venueRequirements')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="referee_requirements" :label="t('refereeRequirements')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportBaseItemTable.page" v-model:page-size="sportBaseItemTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportBaseItemTable.total"
                        @size-change="loadSportBaseItemList()" @current-change="loadSportBaseItemList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportBaseItemList, deleteSportBaseItem } from '@/addon/sport/api/sport_base_item'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportBaseItemTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "category_id":"",
      "name":"",
      "code":"",
      "competition_type":"",
      "gender_type":"",
      "age_group":"",
      "description":"",
      "rules":"",
      "equipment":"",
      "venue_requirements":"",
      "referee_requirements":"",
      "sort":"",
      "status":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取基础项目列表
 */
const loadSportBaseItemList = (page: number = 1) => {
    sportBaseItemTable.loading = true
    sportBaseItemTable.page = page

    getSportBaseItemList({
        page: sportBaseItemTable.page,
        limit: sportBaseItemTable.limit,
         ...sportBaseItemTable.searchParam
    }).then(res => {
        sportBaseItemTable.loading = false
        sportBaseItemTable.data = res.data.data
        sportBaseItemTable.total = res.data.total
    }).catch(() => {
        sportBaseItemTable.loading = false
    })
}
loadSportBaseItemList()

const router = useRouter()

/**
 * 添加基础项目
 */
const addEvent = () => {
    router.push('/sport_base_item/sport_base_item_edit')
}

/**
 * 编辑基础项目
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_base_item/sport_base_item_edit?id='+data.id)
}

/**
 * 删除基础项目
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportBaseItemDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportBaseItem(id).then(() => {
            loadSportBaseItemList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportBaseItemList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
